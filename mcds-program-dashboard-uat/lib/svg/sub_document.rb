module Svg
  class SubDocument < Svg::Base

    def initialize(file_path, filename)

      @file_path  = file_path
      @filename   = filename
      @elements   = []
      @patterns   = []
      @parent_g   = 'Background'
      @gradients  = {}
      @idx        = 0
    end

    def find_or_create
      get_xml
      parse_children(@xml.children)

      @document
    end

    def build_document(doc)
      attrs       = doc.attributes
      dimensions  = attrs['viewBox'].to_s.split(/\s/)
      document    = Document.new(
        name:  @filename,
        width:  dimensions[2],
        height: dimensions[3],
        type_of: 1,
        filename: @file_path.split('canvas/').last
      )

      if document.save
        puts "Building #{document.name}"
        @document = document
      end
    end

    def build_element(elem, zindex, pattern, group)
      element = Element.new(
        name:   elem.name,
        zindex: @idx,
        layer_name: @parent_g
      )

      if element.save
        if pattern
          @patterns.last.elements << element
        else
          @document.elements << element
        end

        @elements << element
        values = build_values(elem, elem.attributes)
        values = values.merge({group_id: group.try(:id)}) if group
        element.update_attribute(:values, values)
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

  end
end
