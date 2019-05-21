class Note < ActiveRecord::Base

  has_many    :document_notes, dependent: :destroy
  has_many    :documents, through: :document_notes
  has_many    :schematics, through: :documents

  belongs_to  :parent, class_name: 'Note'
  has_many    :children, class_name: 'Note', foreign_key: :parent_id
  belongs_to  :source, class_name: 'Note', foreign_key: :source_id
  has_many    :clones, class_name: 'Note', foreign_key: :source_id

  validates :name, uniqueness: true
  validates :width, :height, :body, :name, presence: true

  before_save :bubble_down_changes

  default_scope { where(removed: false) }

  def archived?
    schematics.first ? schematics.first.archived? : true
  end

  def records_for_bubble_down
    # Source overides parent for initial creation, but parent overides source for bubble down
    return Note.none unless self.id

    note_table = Note.arel_table
    schematic_table = Schematic.arel_table

    Note.joins(
      document_notes: {
        document: {
          document_schematics: :schematic
        }
      }
    )
    .where(
      schematic_table[:end_date].gt(Date.today).and(  # Only on unarchived schematics
        note_table[:removed].eq(false)                # Only non-removed notes
      ).and(
        note_table[:parent_id].eq(self.id).or(        # Then grab ALL children
          note_table[:source_id].eq(self.id).and(     # Then grab ONLY clones with
            note_table[:parent_id].eq(nil)            # No assigned parent_id (parent to parent copies)
          )
        )
      )
    )
  end

  def bubble_down_changes
    return if self.archived? # Stop the process if it hits an archived note

    before_changed_attrs = bubble_down_attributes(changed_attributes)      # Of changes (before values), parse out only those applicable columns
    return if before_changed_attrs[:removed]                               # Stop the process if it was removed note BEFORE this process started
    old_parsed_attrs = bubble_down_attributes.merge(before_changed_attrs)  # This merge overwrites current attribs with

    self.records_for_bubble_down.each do |related|
      related.bubble_down_check(old_attributes: old_parsed_attrs, new_attributes: bubble_down_attributes)
    end
  end

  def bubble_down_attributes(attrs = self.attributes)
    # Remove attributes that should not be the same between copies
    attrs.except('created_at', 'updated_at', 'name', 'id', 'source_id', 'parent_id')
  end

  def bubble_down_check(opts)
    # If filtered old attributes match, then they should be changed. Alter this when merge conflict comes into play
    if attributes_match?(opts[:old_attributes])
      self.update_attributes(opts[:new_attributes])
    end
  end

  def attributes_match?(old_parent_attrs)
    # Self bubble down attrs match old parent attrs (filtered previously)
    bubble_down_attributes == old_parent_attrs
  end

  def remove_from_document
    self.update_attributes(removed: true)
  end

end
