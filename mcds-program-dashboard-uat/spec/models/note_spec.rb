require 'rails_helper'

RSpec.describe Note, :type => :model do

  describe '#note schema' do
    it { should respond_to :name }
    it { should respond_to :body }
    it { should respond_to :x}
    it { should respond_to :y}
    it { should respond_to :width}
    it { should respond_to :height}
  end

  describe '#assosciations' do
    it { expect(Note.reflect_on_association(:documents).macro).to   eq(:has_many) }
    it { expect(Note.reflect_on_association(:document_notes).macro).to   eq(:has_many) }
  end

  context "invalid note" do
    describe "required fields" do
      before(:each) do
        @note = Note.new
      end
      it "should return errors if required fields are not set" do
        expect(@note).to be_invalid
      end

      it "should have errors on name body width and height" do
        @note.valid?
        expect(@note.errors[:name].size).to eq(1)
        expect(@note.errors[:body].size).to eq(1)
        expect(@note.errors[:width].size).to eq(1)
        expect(@note.errors[:height].size).to eq(1)
      end
    end
  end

  context "valid note" do
    before(:each) do
      @note = FactoryGirl.build(:note)
    end
    it "should return errors if required fields are not set" do
      expect(@note).to be_valid
    end

    it "should have errors on name body width and height" do
      expect{@note.save}.to change(Note, :count).by(1)
    end
  end

  describe '#records_for_bubble_down' do
    before(:each) do
      parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 3)
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @node = create(:note, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @other_parent = create(:note, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @child = create(:note, parent: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @orphan_clone = create(:note, source: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @sibling_clone = create(:note, source: @node, parent: @other_parent, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1, end_date: Date.today - 9001); document  = create(:document, schematics: [schematic], type_of: 3)
      @archived_child = create(:note, parent: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1, end_date: Date.today - 9001); document  = create(:document, schematics: [schematic], type_of: 3)
      @archived_clone = create(:note, source: @node, parent: @other_parent, documents: [document])
    end

    it 'must return all children and clones without parents' do
      result = @node.reload.records_for_bubble_down
      expect(result).to include(@child, @orphan_clone)
      expect(result).to_not include(@node, @other_parent, @sibling_clone, @archived_clone, @archived_child)
    end

    it 'must return nothing if not yet saved' do
      @node.destroy
      built = build(:note)
      result = built.records_for_bubble_down
      expect(result).to eq([])
    end
  end

  describe 'bubble down process' do
    context 'when saving a record with children' do
      before(:each) do
        schematic = create(:schematic, name: 'cheese schematic', status: 1, id: 1)
        document = create(:document, name: 'cheese document', schematics: [schematic], type_of: 3)

        @parent_note = create(:note, documents: [document], body: 'ol body')
        create(:schematic, name: 'child schem',  parent: schematic, status: 1)
        create(:schematic, name: 'child schem2', parent: schematic, status: 1)

        @unaltered_child = @parent_note.reload.children.first
        @altered_child = @parent_note.children.last
        @altered_child.update_attributes(body: "something changed")
      end

      it 'must only update unaltered children' do
        new_body = "new parent body"
        @parent_note.update_attributes(body: new_body)
        @unaltered_child.reload; @altered_child.reload

        expect(@unaltered_child.body).to eq(new_body)
        expect(@altered_child.body).to_not eq(new_body)
      end

      context 'when the parent is removed' do
        it 'must remove the unaltered child as well' do
          @parent_note.update_attributes(removed: true)
          @unaltered_child.reload; @altered_child.reload
          expect(@unaltered_child.removed).to eq(true)
          expect(@altered_child.removed).to eq(false)
        end
      end

      context 'when the child is removed' do
        before(:each) {create(:schematic, name: 'child schem3', parent: @parent_note.schematics.first, status: 1)}

        it 'must no longer update the child' do
          removed_child = @parent_note.children.last
          removed_child.update_attributes(removed: true)

          new_body = "new parent body"
          @parent_note.update_attributes(body: new_body)
          @unaltered_child.reload; @altered_child.reload; removed_child.reload

          expect(@unaltered_child.body).to eq(new_body)
          expect(@altered_child.body).to_not eq(new_body)
          expect(removed_child.body).to_not eq(new_body)
        end
      end
    end

    context 'when saving a record with clones' do
      before(:each) do
        schematic = create(:schematic, name: 'fun schematic', status: 1, id: 1)
        document = create(:document, name: 'fun document', schematics: [schematic], type_of: 3)

        @source_note = create(:note, documents: [document], body: 'ol body')
        @first_clone = create(:schematic, name: 'clone schem',  source: schematic, status: 1)
        @second_clone = create(:schematic, name: 'clone schem2', source: schematic, status: 1)

        @source_note.reload
        @unaltered_clone = @first_clone.notes.first
        @altered_clone = @second_clone.notes.first
        @altered_clone.update_attributes(body: "something changed")
      end

      it 'must only update unaltered children' do
        new_body = "new source body"
        @source_note.update_attributes(body: new_body)
        @unaltered_clone.reload; @altered_clone.reload

        expect(@unaltered_clone.body).to eq(new_body)
        expect(@altered_clone.body).to_not eq(new_body)
      end

      it 'must not update removed children' do
        new_body = "new source body"
        @source_note.update_attributes(removed: true)
        @source_note.update_attributes(body: new_body)
        @unaltered_clone.reload; @altered_clone.reload

        expect(@unaltered_clone.body).to_not eq(new_body)
        expect(@altered_clone.body).to_not eq(new_body)
      end

      context 'when the clones have child schematics' do
        before(:each) do
          @altered_clone.update_attributes(body: "something changed")
          unatlered_child = create(:schematic, name: 'child of clone schem',  parent: @first_clone, status: 1)
          unatlered_child2 = create(:schematic, name: 'child2 of clone schem', parent: @second_clone, status: 1)
          altered_child = create(:schematic, name: 'child of clone schem2', parent: @second_clone, status: 1)

          @unaltered_clone.reload; @altered_clone.reload
          @unaltered_child = unatlered_child.notes.first
          @altered_child = unatlered_child2.notes.first
          @altered_child.update_attributes(body: 'don change me')
          @altered_child_of_altered   = altered_child.notes.first
        end

        it 'must only update unaltered children of unaltered clones' do
          new_body = "new source parent body"
          @source_note.update_attributes(body: new_body)
          @unaltered_child.reload; @altered_child_of_altered.reload; @unaltered_clone.reload; @altered_clone.reload

          expect(@unaltered_clone.body).to eq(new_body)
          expect(@unaltered_child.body).to eq(new_body)
          expect(@altered_child.body).to_not eq(new_body)

          expect(@altered_clone.body).to_not eq(new_body)
          expect(@altered_child_of_altered.body).to_not eq(new_body)

        end
      end
    end

    context 'when saving a that was different but then changed back' do
      before(:each) do
        parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 3)
        @node = create(:note, documents: [document], body: 'ol body')
        schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @child = @node.children.first
        @child.reload.update_attributes(body: 'Hello from the other side')
        @child.reload.update_attributes(body: @node.body)
      end

      it 'must be changed' do
        expect(@child.reload.body).to eq(@node.reload.body)
        @node.update_attributes(body: 'Nuevo Corpus')
        expect(@child.reload.body).to eq('Nuevo Corpus')
      end
    end

    context 'when one clone with children is archived' do
      before(:each) do
        parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 3)
        @node = create(:note, body: "chicken sauce rocks", documents: [document])

        schematic = create(:schematic, parent: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @child = schematic.notes.first
        @child.body = "chicken sauce rocks"; @child.save
        schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @clone = schematic.notes.first
        @clone.body = "chicken sauce rocks"; @child.save
        schematic = create(:schematic, parent: schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @clone_child = schematic.notes.first
        @clone_child.body = "chicken sauce rocks"; @child.save
        @clone.reload.schematics.first.update_attribute(:end_date, Date.today - 5000)
      end

      it 'must stop the process at the archived node' do
        @node.reload.update_attributes(body: 'so say we all')
        @child.reload; @clone.reload; @clone_child.reload

        expect(@child.body).to eq('so say we all')
        expect(@clone.body).to eq('chicken sauce rocks')
        expect(@clone_child.body).to eq('chicken sauce rocks')
      end
    end
  end
end
