class Element < ActiveRecord::Base

  belongs_to  :layout, class_name: 'Document'
  belongs_to  :parent, class_name: 'Element'
  has_many    :children, class_name: 'Element', foreign_key: :parent_id
  belongs_to  :source, class_name: 'Element', foreign_key: :source_id
  has_many    :clones, class_name: 'Element', foreign_key: :source_id
  has_many    :document_schematics
  has_many    :document_elements
  has_many    :documents, through: :document_elements
  has_many    :schematics, through: :documents
  # has_many    :child_documents, through: :document_schematics, foreign_key: :element_id
  belongs_to  :primary_program, class_name: "Program", foreign_key: :primary_program_id
  belongs_to  :secondary_program, class_name: "Program", foreign_key: :secondary_program_id

  serialize :values, JSON

  enum type_of: [:template_page, :template_layout, :template_g, :page, :layout, :g]

  before_save :check_layout_id
  after_update :bubble_down_worker_kickoff
  after_save :map_program_to_parents, if: :programs_changed?

  scope :with_program_id, -> (program_id) { where("primary_program_id = ? OR secondary_program_id = ?", program_id, program_id)}


  ### CLASS METHODS

  def self.update_id_and_hrefs(asset_id, asset_href)
    return unless (asset_id && asset_href)
    #only run this IF info was supplied. Some assets won't have them defined yet. In case DAM doesn't send them, we never want to nil-out any that were assigned
    self.where(primary_dam_asset_id: asset_id).where.not(primary_dam_asset_path: asset_href).update_all(primary_dam_asset_path: asset_href)
    self.where(secondary_dam_asset_id: asset_id).where.not(secondary_dam_asset_path: asset_href).update_all(secondary_dam_asset_path: asset_href)
  end


  ### INSTANCE METHODS

  def elements_for_bubble_down
    # Source overides parent for initial creation, but parent overides source for bubble down
    return Element.none unless self.id

    element_table = Element.arel_table
    schematic_table = Schematic.arel_table

    Element.joins(
      document_elements: {
        document: {
          document_schematics: :schematic
        }
      }
    ).where(
      schematic_table[:end_date].gt(Date.today).and(   # Only on unarchived schematics
        element_table[:parent_id].eq(self.id).or(      # Then grab ALL children
          element_table[:source_id].eq(self.id).and(   # Then grab ONLY clones with
            element_table[:parent_id].eq(nil)          # No assigned parent_id (parent to parent copies)
          )
        )
      )
    )
  end

  def get_old_parsed_attrs
    return if self.archived? # Stop the process if it hits an archived element
    before_changed_attrs = bubble_down_attributes(true, changed_attributes)      # Of changes (before values), parse out only those applicable columns
    old_parsed_attrs = bubble_down_attributes(true).merge(before_changed_attrs)  # This merge overwrites current attribs with
  end

  def bubble_down_worker_kickoff
    if Rails.env.test?
      BubbleDownWorker.new.perform(self.id, get_old_parsed_attrs, bubble_down_attributes(true))
    else
      BubbleDownWorker.perform_async(self.id, get_old_parsed_attrs, bubble_down_attributes(true))
    end
  end

  def bubble_down_changes(old_parsed_attrs, new_attributes)
    self.elements_for_bubble_down.each do |related|
      related.bubble_down_check(old_attributes: old_parsed_attrs, new_attributes: new_attributes)
    end
  end

  def archived?
    schematics.first ? schematics.first.archived? : true
  end

  def bubble_down_attributes(compare_grayscale = false, attrs = self.attributes)
    # Remove attributes that should not be the same between copies
    except_attrs = ['created_at', 'updated_at', 'parent_id', 'source_id', 'id', 'type_of', 'archived']

    # Grayscale filter will not match between parent and child
    unless compare_grayscale
      except_attrs << ('grayscale')
    end

    attrs.except(*except_attrs)
  end

  def bubble_down_check(opts)
    compare_grayscale = false

    if opts[:old_attributes]['grayscale']
      compare_grayscale = true
    else
      opts[:old_attributes].delete('grayscale')
      opts[:new_attributes].delete('grayscale')
    end

    # If filtered old attributes match, then they should be changed. Alter this when merge conflict comes into play
    if attributes_match?(opts[:old_attributes], compare_grayscale)
      self.update_attributes(opts[:new_attributes])
    end
  end

  def check_layout_id
    return unless self.layout_id && (root_schematic = schematics.first)
    layout_query_attrs = {document_schematics: {schematic_id: root_schematic.id}, id: self.layout_id}
    queried_layout = root_schematic.documents.find_by(layout_query_attrs)

    unless queried_layout
      origin_id = layout.origin_id
      queried_layout = root_schematic.documents.find_by(origin_id: origin_id)

      if queried_layout
        self.layout_id = queried_layout.id
      else
        parent_document = Document.find(self.layout_id)
        new_layout_doc  = root_schematic.build_document(parent_document)
        self.layout_id = new_layout_doc.id
        # NOTE  This does not save to db, just sets the value. This is a before_save hook, so it saves anyway after
        # While this prevents a seperate save call to the db, it means that the method does NOT save on its own
      end
    end
  end

  def attributes_match?(old_parent_attrs, compare_grayscale)
    # Self bubble down attrs match old parent attrs (filtered previously)
    bubble_down_attributes(compare_grayscale) == old_parent_attrs
  end

  private

    def map_program_to_parents
      # this method syncs the relationship between schematics and programs and
      #   between documents and programs. For example, we want to know what
      #   programs a schematic has, and the way we figure that out is based
      #   on the primary and secondary program that each element has within
      #   the schematic
      old_primary_program_id = changed_attributes["primary_program_id"]
      old_secondary_program_id = changed_attributes["secondary_program_id"]
      DocumentProgramSync.new({
        element: self,
        old_primary_program_id: old_primary_program_id,
        old_secondary_program_id: old_secondary_program_id
      }).sync
    end

    def programs_changed?
      primary_program_id_changed? || secondary_program_id_changed?
    end
end
