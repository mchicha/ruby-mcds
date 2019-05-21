module Svg
  class Importer

    def initialize(file_path)
      @schematic  = Schematic.unscoped.find_or_create_by(name: 'Base', sch_type: 2)
      @file_path  = file_path
      @file_name  = File.basename(file_path)
      @name       = 'Base'
      @documents  = []
      @elements   = []
      @patterns   = []
      @parent_g   = 'Background'
      @gradients  = {}
      @idx        = 0
    end

    def find_or_create
      if @schematic
        get_xml
        puts "Building #{@name}"
        parse_children(@xml.children)
      end

      @schematic
    end

    def get_xml
      @file = File.open(@file_path)
      @xml  = Nokogiri::XML(@file.read)
    end

    def parse_children(children, idx=0, pattern=false)
      children.each do |child|
        @idx += 1
        if child.attributes.any?
          case child.name
          when 'svg'
            build_document(child)

          when 'path'
            build_element(child, idx, pattern)

          when 'image'
            build_element(child, idx, pattern)

          when 'linearGradient'
            @gradients[child.attributes['id'].value] = build_lineargradient(child)

          when 'radialGradient'
            @gradients[child.attributes['id'].value] = build_radialgradient(child)

          when 'g'
            if ['Interactive', 'Background', 'Text_Labels'].include?(child.attributes.first[1].value.sub(/_\d_/, ''))
              @parent_g = child.attributes.first[1].value.sub(/_\d_/, '')
            end
          when 'pattern'
            # build_pattern(child)
            # parse_children(child.children, idx+1, true)

          when 'circle'
            build_element(child, idx, pattern)

          when 'ellipse'
            build_element(child, idx, pattern)

          when 'rect'
            build_element(child, idx, pattern)

          when 'line'
            build_element(child, idx, pattern)

          when 'polygon'
            build_element(child, idx, pattern)

          when 'path'
            build_element(child, idx, pattern)

          when 'polyline'
            build_element(child, idx, pattern)

          when 'text'
            build_element(child, idx, pattern)

          end
        end

        parse_children(child.children, idx+1, pattern) if child.children.any? && !%w(radialGradient linearGradient pattern text).include?(child.name)
      end
    end

    def build_document(doc)
      attrs       = doc.attributes
      dimensions  = attrs['viewBox'].to_s.split(/\s/)
      document    = Document.new(
        name:  @file_name.sub('.Svg', ''),
        width:  dimensions[2],
        height: dimensions[3],
      )

      if document.save
        @schematic.documents << document
        @documents << document
      end
    end

    def build_element(elem, zindex, pattern)
      element = Element.new(
        name:   elem.name,
        zindex: @idx,
        layer_name: @parent_g
      )

      if element.save
        if pattern
          @patterns.last.elements << element
        else
          @documents.last.elements << element
        end

        @elements << element
        build_values(element, elem.attributes, elem)
      end
    end

    def build_pattern(pattern)
      attrs       = pattern.attributes
      pattern     = Document.new(
        name:     attrs['id'].value,
        width:    attrs['width'].value,
        height:   attrs['height'].value,
        view_box: attrs['viewBox']
      )

      if pattern.save
        @documents.last.patterns << pattern
        @patterns << pattern
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

    def build_values(elem, attrs, noko_elem=nil)
      values = attrs.inject({}) do |hash, atr|

        at = atr.last
        # # REQUIRE JS PATH WANTS ATTR TO BE DATA NOT D AND NEED TO MAKE SURE ALL PATHS STOP WITH Z
        # if at.name == 'd'
        #   at.name = 'data'
        #   if at.value[-1] != 'z'
        #     at.value = at.value << 'z'
        #   end
        # end

        # if at.name == 'href' && at.value.scan(/data:image\/png;base64,/).empty?
        #   at.value = "/canvas/images/#{File.basename(at.value)}"
        # end

        # # REQUIRE JS REQUIRES THIS BE X AND Y FOR CIRCLE NOT CY OR CX
        # if at.name == 'cx' or at.name == 'cy'
        #   at.name = at.name[1]
        # end
        # if at.name == 'r'
        #   at.name = 'radius'
        # end

        # if %w(points data).include?(at.name)
        #   at.value = at.value.gsub(/\s{2,}/, ' ')
        # end

        case at.name
        when 'd'
          # REQUIRE JS PATH WANTS ATTR TO BE DATA NOT D AND NEED TO MAKE SURE ALL PATHS STOP WITH Z
          at.name = 'data'
          if at.value[-1] != 'z'
            at.value = at.value << 'z'
          end

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

        when 'points', 'data'
          at.value = at.value.gsub(/\s{2,}/, ' ')

        end
        # value = SchematicValue.new(name: at.name, value: at.value.strip)

        # if value.save
        #   elem.values << value
        # end
        hash.merge({at.name => at.value.strip})
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

      # if values['transform']
      #   m = values['transform'].gsub(/matrix\(|\)/, '').split(/\s/)
      #   values['x'] = m[4]
      #   values['y'] = m[5]
      # end

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

      if noko_elem.children && noko_elem.children.size == 1 && noko_elem.children.first.instance_of?(Nokogiri::XML::Text)
        values['text'] = noko_elem.children.first.to_s
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

      if elem.name == 'rect' && values['fill'].nil?
        values['fill'] = '#000000'
      end

      elem.update_attribute(:values, values)
    end
  end
end
