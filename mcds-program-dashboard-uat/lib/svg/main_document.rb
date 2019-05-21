module Svg
  class MainDocument < Svg::Base

    def initialize(file_path, filename, layout_folders, zone_name)
      @schematic      = Schematic.unscoped.find_or_create_by(name: 'Base', sch_type: 2)
      @file_path      = file_path
      @zone           = Zone.find_or_create_by(name: zone_name)
      @layout_folders = layout_folders
      @filename       = filename
      @name           = 'Base'
      @documents      = []
      @groups         = []
      @elements       = []
      @patterns       = []
      @parent_g       = 'Background'
      @gradients      = {}
      @idx            = 0
    end

    def find_or_create
      if @schematic
        get_xml
        puts "Building #{@name}"
        parse_children(@xml.children)
      end

      @schematic
    end

    def build_document(doc)
      attrs           = doc.attributes
      dimensions      = attrs['viewBox'].to_s.split(/\s/)
      background_path = @file_path.sub(File.basename(@file_path), 'background.svg')

      document    = Document.new(
        name:  @filename,
        zone: @zone,
        width:  dimensions[2],
        height: dimensions[3],
        filename: File.basename(@file_path),
        background: background_path.split('/public').last,
        digest: Digest::SHA256.hexdigest(File.read(background_path))
      )

      if document.save
        @schematic.documents << document
        @documents << document
      end
    end

    def build_group(doc)
      group    = Document.new(
        name:  'group',
        width:  0,
        height: 0,
        filename: 'n/a',
        type_of: 2
      )

      if group.save
        @schematic.documents << group
        @groups << group
        values = build_values(doc, doc.attributes)
        group.update_attribute(:values, values)
      end

      group
    end

    def build_element(elem, zindex, pattern, group)
      element = Element.new(
        name:   elem.name,
        zindex: @idx,
        layer_name: @parent_g,
        group: get_group(elem)
      )

      if element.save
        if pattern
          @patterns.last.elements << element
        elsif group
          if elem.name == 'g'
            element.update_attributes(layout_id: group.id, type_of: 2)
            @documents.last.elements << element
          else
            @groups.last.elements << element
          end
        else
          @documents.last.elements << element
        end

        @elements << element
        values = build_values(elem, elem.attributes)
        element.update_attribute(:values, values)
      end

      element
    end

    def get_group(elem)
      group = elem.attributes['id'].to_s.gsub(/(_|x3|[A-z])/, '').scan(/\d{1,2}.\d{1,2}/).first
      if @layout_folders.detect{|f| f.scan(/\d{1,2}.\d{1,2}/).last == group}
        group
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
