class Document < ActiveRecord::Base
  belongs_to  :parent, class_name: 'Document'
  has_many    :children, class_name: 'Document', foreign_key: :parent_id
  belongs_to  :source, class_name: 'Document', foreign_key: :source_id
  belongs_to  :origin, class_name: 'Document', foreign_key: :origin_id
  has_many    :clones, class_name: 'Document', foreign_key: :source_id
  has_many    :document_schematics
  has_many    :schematics, through: :document_schematics
  has_many    :document_elements
  has_many    :elements, through: :document_elements
  has_many    :images
  has_many    :documents_programs
  has_many    :programs, through: :documents_programs
  belongs_to  :zone
  has_many    :document_notes
  has_many    :notes, through: :document_notes

  serialize :values, JSON

  validates :name, presence: true

  enum type_of: [:template_page, :template_layout, :template_g, :page, :layout, :g]

  def bubble_down_attributes(attrs = self.attributes)
    attrs.except('created_at', 'updated_at', 'parent_id', 'source_id', 'id', 'type_of')
  end

  scope :order_zone_sort_nulls_last, ->{
    joins(
      Document.arel_table.join(
        Zone.arel_table, Arel::Nodes::OuterJoin
      ).on(
        Zone.arel_table[:id].eq(Document.arel_table[:zone_id])
      ).join_sources
      # The '-zones...' order is MYSQL to put nulls last
      # PG is: 'zones.sort_order DESC NULLS LAST'
    ).order('-zones.sort_order DESC')
  }

  def descendants_without_matching_note(note)
    document_table = Document.arel_table
    schematic_table = Schematic.arel_table
    matches_query = note_check_sub_select(note)
    sub_query = Arel.sql("(#{matches_query})")


    Document.joins(
      :schematics
    ).where(
      schematic_table[:end_date].gt(Date.today).and(  # Only on unarchived schematics
        document_table[:id].not_in(sub_query).and(
          document_table[:parent_id].eq(self.id).or(
            document_table[:source_id].eq(self.id)
          )
        )
      )
    )
  end

  def note_check_sub_select(note)
    document_table = Document.arel_table
    note_table = Note.arel_table
    schematic_table = Schematic.arel_table

    # Use manual joins here to bypass the default scope on notes
    Document.select(document_table[:id]).joins(
      document_table.join(DocumentNote.arel_table).on(
        document_table[:id].eq(DocumentNote.arel_table[:document_id])
      ).join_sources
    ).joins(
      DocumentNote.arel_table.join(note_table).on(
        DocumentNote.arel_table[:note_id].eq(note_table[:id])
      ).join_sources
    ).where(
      note_table[:parent_id].eq(note.id).or(        # Then grab ALL children
        note_table[:source_id].eq(note.id).and(     # Then grab ONLY clones with
          note_table[:parent_id].eq(nil)            # No assigned parent_id (parent to parent copies)
        )
      )
    ).to_sql
  end

  def note_check_on_descendants(note)
    documents_needing_notes = descendants_without_matching_note(note)
    documents_needing_notes.each do |doc|
      doc.new_bubble_down_note(note)
    end
  end

  def new_bubble_down_note(note)
    note_hash = {parent_id: note.id, name: DateTime.now.strftime('%Q')}
    attrs = note.attributes.except('id', 'created_at', 'updated_at')
    attrs.merge!(note_hash)

    if parent_id.nil?
      attrs[:source_id] = note.id
      attrs.delete('parent_id')
    elsif has_source?
      # if source is given, they share parents
      attrs[:source_id] = attrs[:parent_id]
      attrs[:parent_id] = note.parent_id
    end

    note = self.notes.build(attrs)

    if note.save
      self.notes << note
    end
  end

  def has_source?
    self.source_id.present?
  end

  def has_parent?
    self.parent_id.present?
  end

  def rejoin_programs
    self.programs = programs_through_elements
  end

  def programs_through_elements
    Program.where(
      Program.arel_table[:id].in(self.elements.pluck(:primary_program_id)).or(
        Program.arel_table[:id].in(self.elements.pluck(:secondary_program_id))
      )
    ).where.not(calendar_display: Program.calendar_displays[:no_geographies])
  end
end


