require 'rails_helper'

RSpec.describe Document, :type => :model do
  describe '#assosciations' do
    it { expect(Document.reflect_on_association(:notes).macro).to   eq(:has_many) }
    it { expect(Document.reflect_on_association(:document_notes).macro).to   eq(:has_many) }
  end

  context 'when bubble down is a new note' do
    before(:each) do
      @parent_schem = create(:schematic, id: 1, name: 'prime', status: 1)
      @parent_doc = create(:document, name: 'prime', schematics: [@parent_schem], type_of: 3)
      @parent_note = create(:note, body: 'Thanksgiving is a time of thanks', documents: [@parent_doc])
      @child_schem_with_note = create(:schematic, parent: @parent_schem, name: 'prime', status: 1)
      @child_schem_no_note = create(:schematic, parent: @parent_schem, name: 'prime', status: 1)
      @clone_schem_with_note = create(:schematic, source: @parent_schem, name: 'prime', status: 1)
      @clone_schem_no_note = create(:schematic, source: @parent_schem, name: 'prime', status: 1)
      @child_schem_no_note.notes.first.destroy
      @clone_schem_no_note.notes.first.destroy
    end

    describe '#descendants_without_matching_note' do
      context 'when one child does not have child of the note but one does' do
        it 'must return only that child' do
          results = @parent_doc.descendants_without_matching_note(@parent_doc.notes.first)
          expect(results.order(:id)).to eq([@child_schem_no_note.documents.first, @clone_schem_no_note.documents.first])
        end
      end
    end

    describe '#note_check_on_descendants' do
      it 'must return only that child' do
        expect(@child_schem_with_note.notes.length).to eq(1)
        expect(@child_schem_no_note.notes.length).to eq(0)
        expect(@clone_schem_with_note.notes.length).to eq(1)
        expect(@clone_schem_no_note.notes.length).to eq(0)

        @parent_doc.note_check_on_descendants(@parent_doc.notes.first)

        results = @parent_doc.descendants_without_matching_note(@parent_doc.notes.first)
        expect(results.order(:id)).to eq([])
      end
    end
  end


  describe '#rejoin_programs' do
    it 'must overwrite current program links and replace with ones attached primary or secondary to document elements' do
      geog = create(:geography)
      parents_program = create(:program, geographies: [geog])
      shared_program = create(:program, geographies: [geog])
      child_program = create(:program, geographies: [geog])
      unshown_program = create(:program, calendar_display: Program.calendar_displays[:no_geographies], geographies: [geog])

      parent_schem = create(:schematic, id: 1, name: 'prime', status: 1)
      parent_doc = create(:document, name: 'prime', schematics: [parent_schem], type_of: 3)
      parent_doc.programs << parents_program

      child_schem = create(:schematic, parent: parent_schem, name: 'prime', status: 1)

      doc = child_schem.documents.first

      doc.elements << create(:element, primary_program_id: shared_program.id) << create(:element, secondary_program_id: child_program.id) << create(:element, secondary_program_id: unshown_program.id)

      doc.programs = [parents_program] #forces the test incase other code changes

      doc.rejoin_programs
      expect(doc.reload.programs.sort_by(&:id)).to eq([shared_program, child_program].sort_by(&:id))
    end
  end
end
