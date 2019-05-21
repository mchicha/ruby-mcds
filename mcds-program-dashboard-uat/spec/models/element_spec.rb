require 'rails_helper'

RSpec.describe Element, :type => :model do
  it { should belong_to(:layout) }
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  it { should belong_to(:source) }
  it { should have_many(:clones) }
  it { should have_many(:document_schematics) }
  it { should have_many(:document_elements) }
  it { should have_many(:documents).through(:document_elements) }
  it { should have_many(:schematics).through(:documents) }
  it { should belong_to(:primary_program) }
  it { should belong_to(:secondary_program) }

  describe '#bubble_down_applicable' do
    before(:each) do
      parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 3)
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 0)
      @node = create(:element, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @other_parent = create(:element, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @child = create(:element, parent: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @orphan_clone = create(:element, source: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
      @sibling_clone = create(:element, source: @node, parent: @other_parent, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1, end_date: Date.today - 9001); document  = create(:document, schematics: [schematic], type_of: 3)
      @archived_child = create(:element, parent: @node, documents: [document])
      schematic = create(:schematic, source: parent_schematic, status: 1, end_date: Date.today - 9001); document  = create(:document, schematics: [schematic], type_of: 3)
      @archived_clone = create(:element, source: @node, parent: @other_parent, documents: [document])
    end

    it 'must return all children and clones without parents' do
      result = @node.reload.elements_for_bubble_down
      expect(result).to include(@child, @orphan_clone)
      expect(result).to_not include(@node, @other_parent, @sibling_clone, @archived_clone, @archived_child)
    end

    it 'must return nothing if not yet saved' do
      @node.destroy
      built = build(:element)
      result = built.elements_for_bubble_down
      expect(result).to eq([])
    end
  end

  describe 'bubble down process' do
    context 'when saving a record with children' do
      before(:each) do
        schematic = create(:schematic, name: 'cheese schematic', status: 1, id: 1)
        document = create(:document, name: 'cheese document', schematics: [schematic], type_of: 3)

        @parent_element = create(:element, documents: [document], "name"=>"rect", "zindex"=>998, "editable"=>true, "values"=>{"id"=>"_x31_.9", "x"=>"3160.927", "y"=>"2030.892", "width"=>"286.537", "height"=>"471.385"}, "primary_dam_asset_id"=>109, "layer_name"=>"Interactive", "type_of"=>3, "primary_program_id"=>1)
        create(:schematic, name: 'child schem',  parent: schematic, status: 1)
        create(:schematic, name: 'child schem2', parent: schematic, status: 1)

        @unaltered_child = @parent_element.reload.children.first
        @altered_child = @parent_element.children.last
        @altered_child.update_attributes(name: "something changed")
      end

      it 'must only update unaltered children' do
        new_name = "new parent name"
        @parent_element.update_attributes(name: new_name)
        @unaltered_child.reload; @altered_child.reload

        expect(@unaltered_child.name).to eq(new_name)
        expect(@altered_child.name).to_not eq(new_name)
      end
    end

    context 'when saving a record with clones' do
      before(:each) do
        schematic = create(:schematic, name: 'fun schematic', status: 1, id: 1)
        document = create(:document, name: 'fun document', schematics: [schematic], type_of: 3)

        @source_element = create(:element, documents: [document], "name"=>"rect", "zindex"=>998, "editable"=>true, "values"=>{"id"=>"_x31_.9", "x"=>"3160.927", "y"=>"2030.892", "width"=>"286.537", "height"=>"471.385"}, "primary_dam_asset_id"=>109, "layer_name"=>"Interactive", "type_of"=>3, "primary_program_id"=>1)
        @first_clone = create(:schematic, name: 'clone schem',  source: schematic, status: 1)
        @second_clone = create(:schematic, name: 'clone schem2', source: schematic, status: 1)

        @source_element.reload
        @unaltered_clone = @first_clone.elements.first
        @altered_clone = @second_clone.elements.first
        @altered_clone.update_attributes(name: "something changed")
      end

      it 'must only update unaltered children' do
        new_name = "new source name"
        @source_element.update_attributes(name: new_name)
        @unaltered_clone.reload; @altered_clone.reload

        expect(@unaltered_clone.name).to eq(new_name)
        expect(@altered_clone.name).to_not eq(new_name)
      end

      context 'when the clones have child schematics' do
        before(:each) do
          @altered_clone.update_attributes(name: "something changed")
          unatlered_child = create(:schematic, name: 'child of clone schem',  parent: @first_clone, status: 1)
          unatlered_child2 = create(:schematic, name: 'child2 of clone schem', parent: @second_clone, status: 1)
          altered_child = create(:schematic, name: 'child of clone schem2', parent: @second_clone, status: 1)

          @unaltered_clone.reload; @altered_clone.reload
          @unaltered_child = unatlered_child.elements.first
          @altered_child = unatlered_child2.elements.first
          @altered_child.update_attributes(name: 'don change me')
          @altered_child_of_altered   = altered_child.elements.first
        end

        it 'must only update unaltered children of unaltered clones' do
          new_name = "new source parent name"
          @source_element.update_attributes(name: new_name)
          @unaltered_child.reload; @altered_child_of_altered.reload; @unaltered_clone.reload; @altered_clone.reload

          expect(@unaltered_clone.name).to eq(new_name)
          expect(@unaltered_child.name).to eq(new_name)
          expect(@altered_child.name).to_not eq(new_name)

          expect(@altered_clone.name).to_not eq(new_name)
        end

        it 'must not overwrite grayscale filter' do
          expect(@unaltered_clone.grayscale).to eq(true)

          new_name = "new source parent name"
          @source_element.update_attributes(name: new_name)
          expect(@unaltered_clone.grayscale).to eq(true)
        end

        context 'when updating a clone element that was grayscaled' do
          it 'must remove grayscale from the child as well ' do
            expect(@unaltered_child.reload.grayscale).to eq(true)
            @unaltered_clone.grayscale = false
            @unaltered_clone.save

            expect(@unaltered_child.reload.grayscale).to eq(false)
          end
        end
      end
    end

    context 'when saving a that was different but then changed back' do
      before(:each) do
        parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 1)
        @node = create(:element, documents: [document])
        schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @child = create(:element, parent: @node, documents: [document])
        @child.reload.update_attributes(values: @node.values)
      end

      it 'must be changed' do
        expect(@child.reload.values).to eq(@node.reload.values)
        @node.update_attributes(values: {'test' => 'blah'})
        expect(@child.reload.values).to eq({'test' => 'blah'})
      end
    end

    context 'when one clone with children is archived' do
      before(:each) do
        parent_schematic = create(:schematic, id: 1, status: 1); document  = create(:document, schematics: [parent_schematic], type_of: 1)
        @node = create(:element, values: {'awake' => 'iron'}, documents: [document])
        schematic = create(:schematic, parent: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @child = create(:element, parent: @node, values: {'awake' => 'iron'}, documents: [document])
        schematic = create(:schematic, source: parent_schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @clone = create(:element, source: @node, values: {'awake' => 'iron'}, documents: [document])
        schematic = create(:schematic, parent: schematic, status: 1); document  = create(:document, schematics: [schematic], type_of: 3)
        @clone_child = create(:element, parent: @clone, values: {'awake' => 'iron'}, documents: [document])
        @clone.reload.schematics.first.update_attribute(:end_date, Date.today - 5000)
      end

      it 'must stop the process at the archived node' do
        @node.reload.update_attributes(values: {'so_say' => 'we all'})
        @child.reload; @clone.reload; @clone_child.reload

        expect(@child.values).to eq({'so_say' => 'we all'})
        expect(@clone.values).to eq({'awake' => 'iron'})
        expect(@clone_child.values).to eq({'awake' => 'iron'})
      end
    end
  end
end
