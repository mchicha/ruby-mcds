module Svg
  class Base

    def get_xml
      @file = File.open(@file_path)
      @xml  = Nokogiri::XML(@file.read)
    end

    def parse_children(children, idx=0, pattern=false, group=nil)
      children.each do |child|
        @idx += 1
        if child.attributes.any?
          case child.name
          when 'svg'
            if child.attributes['id'] && ['Interactive', 'Background', 'Text_Labels', 'Mask'].include?(child.attributes['id'].value.sub(/_\d_/, ''))
              @parent_g = child.attributes['id'].value.sub(/_\d_/, '')
            end
            build_document(child)

          when 'path'
            build_element(child, idx, pattern, group)

          when 'image'
            build_element(child, idx, pattern, group)

          when 'linearGradient'
            @gradients[child.attributes['id'].value] = build_lineargradient(child)

          when 'radialGradient'
            @gradients[child.attributes['id'].value] = build_radialgradient(child)

          when 'g'
            if ['Interactive', 'Background', 'Text_Labels', 'Mask'].include?(child.attributes.first[1].value.sub(/_\d_/, ''))
              @parent_g = child.attributes.first[1].value.sub(/_\d_/, '')
            end

            if child.attributes.except('id').any?
              group   = build_group(child)
              element = build_element(child, idx, pattern, group)
            end

          when 'pattern'
            # build_pattern(child)
            # parse_children(child.children, idx+1, true)

          when 'circle'
            build_element(child, idx, pattern, group)

          when 'ellipse'
            build_element(child, idx, pattern, group)

          when 'rect'
            build_element(child, idx, pattern, group)

          when 'line'
            build_element(child, idx, pattern, group)

          when 'polygon'
            build_element(child, idx, pattern, group)

          when 'path'
            build_element(child, idx, pattern, group)

          when 'polyline'
            build_element(child, idx, pattern, group)

          when 'text'
            build_element(child, idx, pattern, group)

          end
        end

        parse_children(child.children, 0, pattern, group) if child.children.any? && !%w(radialGradient linearGradient pattern text).include?(child.name)
      end
    end

    def build_lineargradient(elem)
      h = {
        'fillLinearGradientStartPoint' => {x: elem.attributes['x1'].value.to_f, y: elem.attributes['y1'].value.to_f},
        'fillLinearGradientEndPoint' =>   {x: elem.attributes['x2'].value.to_f, y: elem.attributes['y2'].value.to_f},
        'fillLinearGradientColorStops' => color_stops(elem.children)
      }

      if elem.attributes['gradientTransform']
        transform = elem.attributes['gradientTransform'].value.gsub(/matrix\(|\)/, '').split(/\s|,/).map(&:to_f)

        h['fillPatternScale'] = {
          x: transform[0],
          y: transform[3]
        }

        h['fillPatternX'] = transform[4]
        h['fillPatternY'] = transform[5]

      end

      h
    end

    def build_radialgradient(elem)
      h = {
        'fillRadialGradientStartPoint'  => {x: elem.attributes['cx'].value.to_f, y: elem.attributes['cy'].value.to_f},
        'fillRadialGradientEndPoint'    => {x: elem.attributes['cx'].value.to_f, y: elem.attributes['cy'].value.to_f},
        'fillRadialGradientStartRadius' => 0,
        'fillRadialGradientEndRadius'   =>   elem.attributes['r'].value.to_f,
        'fillRadialGradientColorStops'  => color_stops(elem.children)
      }

      if elem.attributes['gradientTransform']
        transform = elem.attributes['gradientTransform'].value.gsub(/matrix\(|\)/, '').split(/\s|,/).map(&:to_f)
        h['fillPatternScale'] = {
          x: transform[0],
          y: transform[3]
        }

        h['fillPatternX'] = transform[1]
        h['fillPatternY'] = transform[2]

      end

      h
    end

    def color_stops(children)
      children.map do |child|
        if child.name == 'stop'
          [child.attributes['offset'].value, child.attributes['style'].value.scan(/#[a-fA-F0-9]{6}/)[0]]
        end
      end.flatten.compact
    end

    def build_values(elem, attrs)
      values = attrs.inject({}) do |hash, atr|

        at = atr.last

        case at.name
        when 'd'
          # REQUIRE JS PATH WANTS ATTR TO BE DATA NOT D AND NEED TO MAKE SURE ALL PATHS STOP WITH Z
          at.name = 'data'
          if at.value[-1] != 'z'
            at.value = at.value << 'z'
          end

        when 'g'
          at.name = 'group'

        when 'href'
          at.name == 'href'
          if at.value.scan(/data:image\/png;base64,/).empty?
            at.value = "/canvas/images/#{File.basename(at.value)}"
          end

        when 'cx', 'cy'
          # REQUIRE JS REQUIRES THIS BE X AND Y FOR CIRCLE NOT CY OR CX
          at.name = at.name[1]

        when 'r'
          at.name = 'radius'
        when 'id'
          if at.value.match(/\d/)
            val = at.value.scan(/\d_\d*.\d+/).first
            if val.present?
              at.value = val.gsub(/_/, '')
            end
          end

        when 'points', 'data'
          at.value = at.value.gsub(/\s{2,}/, ' ')

        end

        hash.merge({at.name => at.value.strip})
      end

      if elem.name == 'line'
        values['points'] = "#{attrs['x1'].value.to_f.abs},#{attrs['y1'].value.to_f.abs} #{attrs['x2'].value.to_f.abs},#{attrs['y2'].value.to_f.abs}"
        values.delete('x1')
        values.delete('x2')
        values.delete('y1')
        values.delete('y2')
        values['fill'] = values['stroke']
      end

      if elem.name == 'ellipse'
        values['radius'] = {
          x: values['rx'],
          y: values['ry']
        }

        values.delete('rx')
        values.delete('ry')
      end

      if %w(rect ellipse).include?(elem.name) && values['fill'].nil?
        values['fill'] = '#000000'
      end

      if values['transform']
        transform = values['transform'].gsub(/matrix\(|\)/, '').split(/\s|,/).map(&:to_f)

        values['scale'] = {
          x: transform[0],
          y: transform[3]
        }

        values['skew'] = {
          x: transform[1],
          y: transform[2]
        }

        values['x'] = transform[4];
        values['y'] = transform[5];

      end

      if values['stroke-linecap']
        values['linecap'] = values['stroke-linecap']
        values.delete('stroke-linecap')
      end

      if values['stroke-dasharray']
        values['dash'] = values['stroke-dasharray']
        values.delete('stroke-dasharray')
      end

      if values['font-family']
        values['fontFamily'] = values['font-family']
        values.delete('font-family')
      end

      if values['font-size']
        values['fontSize'] = values['font-size'].to_i
        values['y'] = values['y'].to_i - (values['fontSize'] / 1.3).to_i
        values.delete('font-size')
      end

      if values['stroke-linecap']
        values['linecap'] = values['stroke-linecap']
        values.delete('stroke-linecap')
      end

      if values['clip-rule']
        values['mozFillRule'] = values['clip-rule']
        values.delete('clip-rule')
      end

      if values['fill'] && values['fill'].scan(/url\(#[\w]+\)/).any?
        key = values['fill'].gsub(/url\(#|\)/, '')
        if @gradients[key]
          values.merge!(@gradients[key])
          values.delete('fill')
          if values['x'] && values['y'] && values['fillLinearGradientStartPoint']
            values['fillLinearGradientEndPoint'][:x]    = values['fillLinearGradientEndPoint'][:x] - values['fillLinearGradientStartPoint'][:x]
            values['fillLinearGradientStartPoint'][:x]  = 0
          end
        end
      end

      # THIS VALUES ALSO HAS TO BE REMOVED OR DOCUMENT FIXED  values['fill'] == '#CBEAED'
      if values['fill'] && (values['fill'] == 'none')
        values.delete('fill')
      end

      if elem.children && elem.children.size == 1 && elem.children.first.instance_of?(Nokogiri::XML::Text)
        values['text'] = elem.children.first.to_s
      end

      values
    end
  end
end
