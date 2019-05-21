require 'rails_helper'

RSpec.describe Schematic, :type => :model do

  it { expect(Schematic.reflect_on_association(:images).macro).to eq(:has_many) }
  it { expect(Schematic.reflect_on_association(:notes).macro).to eq(:has_many) }

  describe '#propogate_changes_to_children' do
    before(:each) do
      @schematic = create(:schematic, id: 1, status: 0, name: 'ooooh yeah')
      @child_matching_none = create(:schematic, status: 0, name: 'unchained', parent: @schematic, release_date: @schematic.release_date - 37, end_date: @schematic.end_date + 37)
      @child_matching_name = create(:schematic, status: 0, name: 'ooooh yeah', release_date: @schematic.release_date - 16, end_date: @schematic.end_date + 16, parent: @schematic)
      @child_matching_dates = create(:schematic, status: 0,name: 'OH NO!', parent: @schematic, release_date: @schematic.release_date, end_date: @schematic.end_date)
      @child_matching_end_date = create(:schematic, status: 0, name: 'OH NOPE!', parent: @schematic, release_date: @schematic.release_date - 400, end_date: @schematic.end_date)
      @child_matching_both = create(:schematic, status: 0, name: 'ooooh yeah', parent: @schematic, release_date: @schematic.release_date, end_date: @schematic.end_date)
      @schematic.reload
    end

    it 'must update fields that match' do
      @schematic.update_attributes(name: 'CHANGED', release_date: @schematic.release_date - 84, end_date: @schematic.end_date + 84)
      expect(@child_matching_none.reload.name).to_not eq(@schematic.name)
      expect(@child_matching_none.release_date).to_not eq(@schematic.release_date)
      expect(@child_matching_none.end_date).to_not eq(@schematic.end_date)

      expect(@child_matching_name.reload.name).to eq(@schematic.name)
      expect(@child_matching_name.release_date).to_not eq(@schematic.release_date)
      expect(@child_matching_name.end_date).to_not eq(@schematic.end_date)

      expect(@child_matching_dates.reload.name).to_not eq(@schematic.name)
      expect(@child_matching_dates.release_date).to eq(@schematic.release_date)
      expect(@child_matching_dates.end_date).to eq(@schematic.end_date)

      expect(@child_matching_end_date.reload.name).to_not eq(@schematic.name)
      expect(@child_matching_end_date.release_date).to_not eq(@schematic.release_date)
      expect(@child_matching_end_date.end_date).to eq(@schematic.end_date)


      expect(@child_matching_both.reload.name).to eq(@schematic.name)
      expect(@child_matching_both.release_date).to eq(@schematic.release_date)
      expect(@child_matching_both.end_date).to eq(@schematic.end_date)
    end

    it 'must not fire if schematic is effectively archived' do
      @schematic.update_attributes(release_date: @schematic.release_date - 684, end_date: @schematic.end_date - 584)
      @schematic.update_attributes(name: 'CHANGED')

      expect(@child_matching_name.reload.name).to_not eq(@schematic.name)
      expect(@child_matching_dates.release_date).to_not eq(@schematic.release_date)
      expect(@child_matching_dates.end_date).to_not eq(@schematic.end_date)
      expect(@child_matching_end_date.end_date).to_not eq(@schematic.end_date)
    end
  end

  describe '#build_schematic' do
    before(:each) do
      @parent = create(:schematic, id: 1, status: 1)
      document = create(:document, name: 'veritas', schematics: [@parent], type_of: 0)
      create(:element, name: 'Odyssey', documents: [document])
      create(:note, body: 'Iliyad', documents: [document])
    end


    context 'with a parent' do
      it 'must copy the parent documents, notes, and elements' do
        schematic = create(:schematic, parent_id: @parent.id, status: 1)
        expect(schematic.documents.count).to eq(@parent.documents.count)
        expect(schematic.documents.first.name).to eq(@parent.documents.first.name)

        expect(schematic.elements.count).to eq(@parent.elements.count)
        expect(schematic.elements.first.name).to eq(@parent.elements.first.name)

        expect(schematic.notes.count).to eq(@parent.notes.count)
        expect(schematic.notes.first.body).to eq(@parent.notes.first.body)
      end

    end

    context 'with a source' do
      before(:each) do
        @source = create(:schematic, status: 1)
        @source.documents = []
        document = create(:document, name: 'equitas', schematics: [@source], type_of: 3)
        document2 = create(:document, name: 'liberdad', schematics: [@source], type_of: 3)
        create(:element, name: 'Aquarius', documents: [document])
        create(:element, name: 'Houston', documents: [document2])

        create(:note, body: 'Columbia', documents: [document])
        create(:note, body: 'Eagle', documents: [document2])
        @source.reload
      end

      it 'must copy documents and elements from the source, not the parent, but assign to both' do
        schematic = create(:schematic, parent_id: @parent.id, source_id: @source.id, status: 1)

        expect(schematic.documents.count).to_not eq(@parent.documents.count)
        expect(schematic.documents.first.name).to_not eq(@parent.documents.first.name)

        expect(schematic.documents.count).to eq(@source.documents.count)
        expect(schematic.documents.first.name).to eq(@source.documents.first.name)

        expect(schematic.elements.count).to_not eq(@parent.elements.count)
        expect(schematic.elements.first.name).to_not eq(@parent.elements.first.name)

        expect(schematic.elements.count).to eq(@source.elements.count)
        expect(schematic.elements.first.name).to eq(@source.elements.first.name)

        expect(schematic.notes.count).to eq(@source.notes.count)
        expect(schematic.notes.first.body).to eq(@source.notes.first.body)
        expect(schematic.notes.last.body).to eq(@source.notes.last.body)

        expect(schematic.documents.first.bubble_down_attributes).to eq(@source.documents.first.bubble_down_attributes)
        expect(schematic.elements.first.source.bubble_down_attributes).to eq(@source.elements.first.bubble_down_attributes)
      end
    end

    context 'with the parents source having a matching geography child' do
      before(:each) do
        @source = create(:schematic, status: 1)
        @source.elements.first.update_attributes(primary_dam_asset_path: 'blah', primary_dam_asset_id: 17, values: {id: "EVM_Full_Shape"})


        @layout = create(:document, name: '4.10', filename: "Drive Thru Zone/Drive Thru Zone - FP43/Container_16.18/Schematic_dthru_16.54_2Third_bottom.svg", schematics: [@source], type_of: 'layout')
        create(:element, name: 'super-duper-rect', documents: [@layout], values: {height: "519.88"}, primary_dam_asset_id: 44)


        @layout_pointing = create(:element, name: 'rect', documents: [@source.documents.first], group: '4.10', layout: @layout)


        @geography = create(:geography, name: 'sample')

        @source_child = create(:schematic, parent: @source, geographies: [@geography], status: 1)
        @source_child.elements.first.update_attributes(primary_dam_asset_path: 'changed', primary_dam_asset_id: 42)

        @source_child.elements.where(name: 'super-duper-rect').first.update_attributes(primary_dam_asset_id: 17)

        @source_child.reload
      end

      it 'must copy the element information from the parent source child of the same geograhpy' do
        parent = create(:schematic, source: @source, status: 1)
        expect(parent.elements.first.primary_dam_asset_id).to_not eq(@source_child.elements.first.primary_dam_asset_id)
        expect(parent.elements.first.primary_dam_asset_path).to_not eq(@source_child.elements.first.primary_dam_asset_path)

        child = create(:schematic, parent: parent, status: 1, geographies: [@geography])

        expect(child.elements.first.primary_dam_asset_id).to  eq(@source_child.elements.first.primary_dam_asset_id)
        expect(child.elements.first.primary_dam_asset_path).to eq(@source_child.elements.first.primary_dam_asset_path)

        expect(child.elements.where(name: 'super-duper-rect').first.primary_dam_asset_id).to eq(@source_child.elements.where(name: 'super-duper-rect').first.primary_dam_asset_id)

      end
    end
  end

  describe '.index_for_selected_geographies' do
    before(:each) do
      @nat_geo = create(:geography, :national)
      @child_geo1 = create(:geography, name: 'CheeseCitay')
      @child_geo2 = create(:geography, name: 'Wall Drug')
      @child_geo3 = create(:geography, name: 'Mel Tomei')

      @national_schematic = create(:schematic, name: 'root', status: 1, id: 1, geographies: [@nat_geo])

      @planning_copied_schematic   = create(:schematic, name: 'clone', status: 0, source: @national_schematic, geographies: [@nat_geo])
      @published_copied_schematic  = create(:schematic, name: 'clone', status: 1, source: @national_schematic, geographies: [@nat_geo])
      @archived_published_copied_schematic   = create(:schematic, name: 'clone', status: 1, source: @national_schematic, geographies: [@nat_geo], end_date: (Date.today - 400))

      @planning_selected_parent_schematic   = create(:schematic, name: 'clone', status: 0, source: @national_schematic, geographies: [@child_geo1, @child_geo2])
      @published_selected_parent_schematic  = create(:schematic, name: 'clone', status: 1, source: @national_schematic, geographies: [@child_geo1, @child_geo2])
      @archived_published_selected_parent_schematic   = create(:schematic, name: 'clone', status: 1, source: @national_schematic, geographies: [@child_geo1, @child_geo2], end_date: (Date.today - 400))

      @with_child_parent         = create(:schematic, name: 'clone', status: 1, source: @national_schematic, geographies: [@child_geo1, @child_geo2])
      @child_of_selected         = create(:schematic, name: 'child', status: 1, parent: @with_child_parent, geographies: [@child_geo1])

      @other_selected_schematic   = create(:schematic, name: 'child', status: 1, source: @national_schematic, geographies: [@child_geo2, @child_geo3])

      @planning_child_schematic   = create(:schematic, name: 'child', status: 0, parent: @national_schematic, geographies: [@child_geo1])
      @published_child_schematic   = create(:schematic, name: 'child', status: 1, parent: @national_schematic, geographies: [@child_geo1])
      @archived_published_child_schematic  = create(:schematic, name: 'child', status: 1, parent: @national_schematic, geographies: [@child_geo1], end_date: (Date.today - 400))

      @other_child_schematic      = create(:schematic, name: 'child', status: 1, parent: @national_schematic, geographies: [@child_geo2])
    end

    context 'as an admin' do
      before(:each) {@admin = create(:user, role: 0)}
      context 'with coop selected' do
        it 'must return parent schematics (without children assigned) and child assigned' do
          results = Schematic.index_for_selected_geographies(user: @admin, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@planning_copied_schematic.id, @published_copied_schematic.id, @archived_published_copied_schematic.id, @planning_selected_parent_schematic.id, @published_selected_parent_schematic.id, @archived_published_selected_parent_schematic.id, @child_of_selected.id, @planning_child_schematic.id, @archived_published_child_schematic.id, @published_child_schematic.id].sort)
        end
      end

      context 'with national selected' do
        it 'must return all parent schematics' do
          results = Schematic.index_for_selected_geographies(user: @admin, geography_ids: [@nat_geo.id]).pluck(:id)
          expect(results.sort).to eq([@national_schematic.id, @planning_copied_schematic.id, @published_copied_schematic.id, @archived_published_copied_schematic.id, @planning_selected_parent_schematic.id, @published_selected_parent_schematic.id, @archived_published_selected_parent_schematic.id, @with_child_parent.id, @other_selected_schematic.id].sort)
        end
      end
    end

    context 'as an inputter' do
      before(:each) {@inputter = create(:user, role: 1)}

      context 'with an assigned coop selected' do
        before(:each) {@inputter.geographies << @child_geo1}
        it 'must return published or planning nationals, and all assigned geographies' do
          results = Schematic.index_for_selected_geographies(user: @inputter, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@published_copied_schematic.id, @archived_published_copied_schematic.id, @published_selected_parent_schematic.id, @archived_published_selected_parent_schematic.id, @child_of_selected.id, @planning_child_schematic.id, @archived_published_child_schematic.id, @published_child_schematic.id].sort)
        end
      end

      context 'with a non-assigned coop selected' do
        before(:each) {@inputter.geographies << @child_geo2}
        it 'must return published children for assigned geographies only' do
          results = Schematic.index_for_selected_geographies(user: @inputter, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@child_of_selected.id, @published_child_schematic.id, @archived_published_child_schematic.id].sort)
        end
      end

      context 'with national selected' do
        it 'must return published and archived parent schematics' do
          results = Schematic.index_for_selected_geographies(user: @inputter, geography_ids: [@nat_geo.id]).pluck(:id)
          expect(results.sort).to eq([@national_schematic.id, @published_copied_schematic.id, @archived_published_copied_schematic.id, @published_selected_parent_schematic.id, @archived_published_selected_parent_schematic.id, @with_child_parent.id, @other_selected_schematic.id].sort)
        end
      end
    end

    # leadership and read_only are the same right now, but most likely will change
    context 'as a leadership' do
      before(:each) {@leadership = create(:user, role: 2)}

      context 'with an assigned coop selected' do
        before(:each) {@leadership.geographies << @child_geo1}
        it 'must return published children for assigned geographies only even though assigned to the coop' do
          results = Schematic.index_for_selected_geographies(user: @leadership, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@child_of_selected.id, @published_child_schematic.id, @archived_published_child_schematic.id].sort)
        end
      end

      context 'with a non-assigned coop selected' do
        before(:each) {@leadership.geographies << @child_geo2}
        it 'must return published children for assigned geographies only' do
          results = Schematic.index_for_selected_geographies(user: @leadership, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@child_of_selected.id, @published_child_schematic.id, @archived_published_child_schematic.id].sort)
        end
      end

      context 'with national selected' do
        it 'must return published parent schematics' do
          results = Schematic.index_for_selected_geographies(user: @leadership, geography_ids: [@nat_geo.id]).pluck(:id)
          expect(results.sort).to eq([@national_schematic.id, @published_copied_schematic.id, @published_selected_parent_schematic.id, @archived_published_copied_schematic.id, @archived_published_selected_parent_schematic.id, @with_child_parent.id, @other_selected_schematic.id].sort)
        end
      end
    end

    context 'as a read_only' do
      before(:each) {@read_only = create(:user, role: 3)}

      context 'with an assigned coop selected' do
        before(:each) {@read_only.geographies << @child_geo1}
        it 'must return published children for assigned geographies only even though assigned to the coop' do
          results = Schematic.index_for_selected_geographies(user: @read_only, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@child_of_selected.id, @published_child_schematic.id, @archived_published_child_schematic.id].sort)
        end
      end

      context 'with a non-assigned coop selected' do
        before(:each) {@read_only.geographies << @child_geo2}
        it 'must return published children for assigned geographies only' do
          results = Schematic.index_for_selected_geographies(user: @read_only, geography_ids: [@child_geo1.id]).pluck(:id)
          expect(results.sort).to eq([@child_of_selected.id, @published_child_schematic.id, @archived_published_child_schematic.id].sort)
        end
      end

      context 'with national selected' do
        it 'must return published parent schematics' do
          results = Schematic.index_for_selected_geographies(user: @read_only, geography_ids: [@nat_geo.id]).pluck(:id)
          expect(results.sort).to eq([@national_schematic.id, @published_copied_schematic.id, @published_selected_parent_schematic.id, @archived_published_copied_schematic.id, @archived_published_selected_parent_schematic.id, @with_child_parent.id, @other_selected_schematic.id].sort)
        end
      end
    end


    describe '#queue_render' do
      before(:each) do
        @schematic = create(:schematic, status: 1)
        @set = Sidekiq::ScheduledSet.new
      end

      it "should have a queue_render method" do
        expect(@schematic).to respond_to(:queue_render)
      end

      it "should add a Schematic worker to the Sidekiq Queue" do
        expect{ @schematic.queue_render }.to change{ @set.size }.by(1)
      end
    end

    describe '#generate_pdf' do
      before(:each) do
        @schematic = create(:schematic, status: 1)
        WickedPdf.any_instance.stub(:pdf_from_url).and_return("PDF sting I/O")
      end

      it "should have a queue_render method" do
        expect(@schematic).to respond_to(:generate_pdf)
      end

      it "should return a string" do
        expect(@schematic.generate_pdf).to eq('PDF sting I/O')
      end
    end

    describe '#render_pdf' do
      before(:each) do
        @schematic = build(:schematic, status: 1)
        WickedPdf.any_instance.stub(:pdf_from_url).and_return("PDF sting I/O")
        @set = Sidekiq::ScheduledSet.new
      end

      it "should respond to render_pdf" do
        expect(@schematic).to respond_to(:render_pdf)
      end

    end

  end

  describe 'scope by_status' do
    before(:each) do
      schematic = create(:schematic, id: 1, status: 0, name: 'base schematic')

      @planning_schematic = create(:schematic, source: schematic, status: 0, name: 'planning_schematic')
      @published_schematic = create(:schematic, source: schematic, status: 1, name: 'published_schematic')
      @archived_planning_schematic = create(:schematic, source: schematic, status: 0, name: 'archived_planning_schematic', release_date: (Date.today - 410), end_date: (Date.today - 400))
      @archived_published_schematic = create(:schematic, source: schematic, status: 1, name: 'archived_published_schematic', release_date: (Date.today - 410), end_date: (Date.today - 400))


      @plan_child_of_planning = create(:schematic, parent: @planning_schematic, status: 0, name: 'plan_child_of_planning')
      @pub_child_of_planning = create(:schematic, parent: @planning_schematic, status: 1, name: 'pub_child_of_planning')
      @arc_plan_child_of_planning = create(:schematic, parent: @planning_schematic, status: 0, name: 'arc_plan_child_of_planning', release_date: (Date.today - 410), end_date: (Date.today - 400))
      @arc_pub_child_of_planning = create(:schematic, parent: @planning_schematic, status: 1, name: 'arc_pub_child_of_planning', release_date: (Date.today - 410), end_date: (Date.today - 400))


      @plan_child_of_published = create(:schematic, parent: @published_schematic, status: 0, name: 'plan_child_of_published')
      @pub_child_of_published = create(:schematic, parent: @published_schematic, status: 1, name: 'pub_child_of_published')
      @arc_plan_child_of_published = create(:schematic, parent: @published_schematic, status: 0, name: 'arc_plan_child_of_published', release_date: (Date.today - 410), end_date: (Date.today - 400))
      @arc_pub_child_of_published = create(:schematic, parent: @published_schematic, status: 1, name: 'arc_pub_child_of_published', release_date: (Date.today - 410), end_date: (Date.today - 400))



      @plan_child_of_archived_planning = create(:schematic, parent: @archived_planning_schematic, status: 0, name: 'plan_child_of_archived_planning')
      @plan_child_of_archived_planning.update_attributes(release_date: (Date.today - 4), end_date: (Date.today + 40))
      @pub_child_of_archived_planning = create(:schematic, parent: @archived_planning_schematic, status: 1, name: 'pub_child_of_archived_planning')
      @pub_child_of_archived_planning.update_attributes(release_date: (Date.today - 4), end_date: (Date.today + 40))
      @arc_plan_child_of_archived_planning = create(:schematic, parent: @archived_planning_schematic, status: 0, name: 'arc_plan_child_of_archived_planning', release_date: (Date.today - 410), end_date: (Date.today - 400))
      @arc_pub_child_of_archived_planning = create(:schematic, parent: @archived_planning_schematic, status: 1, name: 'arc_pub_child_of_archived_planning', release_date: (Date.today - 410), end_date: (Date.today - 400))


      @plan_child_of_archived_published = create(:schematic, parent: @archived_published_schematic, status: 0, name: 'plan_child_of_archived_published')
      @plan_child_of_archived_published.update_attributes(release_date: (Date.today - 4), end_date: (Date.today + 40))
      @pub_child_of_archived_published = create(:schematic, parent: @archived_published_schematic, status: 1, name: 'pub_child_of_archived_published')
      @pub_child_of_archived_published.update_attributes(release_date: (Date.today - 4), end_date: (Date.today + 40))
      @arc_plan_child_of_archived_published = create(:schematic, parent: @archived_published_schematic, status: 0, name: 'arc_plan_child_of_archived_published', release_date: (Date.today - 410), end_date: (Date.today - 400))
      @arc_pub_child_of_archived_published = create(:schematic, parent: @archived_published_schematic, status: 1, name: 'arc_pub_child_of_archived_published', release_date: (Date.today - 410), end_date: (Date.today - 400))


      schematic.update_attributes(status: nil)
    end

    context 'when only planning' do
      it 'must return active planning schematics' do
        result = Schematic.by_status(0).pluck(:id).sort
        expect(Schematic.by_status('planning').pluck(:id).sort).to eq(result)
        expect(result).to eq([@planning_schematic, @plan_child_of_planning, @arc_plan_child_of_planning, @plan_child_of_published, @arc_plan_child_of_published].map(&:id).sort)
      end
    end

    context 'when only published' do
      it 'must return active published schematics' do
        result = Schematic.by_status(1).pluck(:id).sort
        expect(Schematic.by_status('published').pluck(:id).sort).to eq(result)
        expect(result).to eq([@published_schematic, @pub_child_of_published, @arc_pub_child_of_planning, @pub_child_of_planning, @arc_pub_child_of_published].map(&:id).sort)
      end
    end

    context 'when only archived' do
      it 'must all archived schematics' do
        result = Schematic.by_status(2).pluck(:id).sort
        expect(Schematic.by_status('archived').pluck(:id).sort).to eq(result)
        expect(result).to eq([@archived_planning_schematic, @archived_published_schematic, @plan_child_of_archived_planning, @pub_child_of_archived_planning, @arc_plan_child_of_archived_planning, @arc_pub_child_of_archived_planning, @plan_child_of_archived_published, @pub_child_of_archived_published, @arc_plan_child_of_archived_published, @arc_pub_child_of_archived_published].map(&:id).sort)
      end
    end

    context 'when all but planning' do
      it 'must not return active planning schematics' do
        result = Schematic.by_status([1,2]).pluck(:id).sort
        expect(Schematic.by_status(['published', 'archived']).pluck(:id).sort).to eq(result)
        expect(result).to eq([@published_schematic, @pub_child_of_published, @arc_pub_child_of_planning, @pub_child_of_planning, @arc_pub_child_of_published, @archived_planning_schematic, @archived_published_schematic, @plan_child_of_archived_planning, @pub_child_of_archived_planning, @arc_plan_child_of_archived_planning, @arc_pub_child_of_archived_planning, @plan_child_of_archived_published, @pub_child_of_archived_published, @arc_plan_child_of_archived_published, @arc_pub_child_of_archived_published].map(&:id).sort)
      end
    end

    context 'when all but published' do
      it 'must not return active published schematics' do
        result = Schematic.by_status([0,2]).pluck(:id).sort
        expect(Schematic.by_status(['planning', 'archived']).pluck(:id).sort).to eq(result)
        expect(result).to eq([@planning_schematic, @plan_child_of_planning, @arc_plan_child_of_planning, @plan_child_of_published, @arc_plan_child_of_published, @archived_planning_schematic, @archived_published_schematic, @plan_child_of_archived_planning, @pub_child_of_archived_planning, @arc_plan_child_of_archived_planning, @arc_pub_child_of_archived_planning, @plan_child_of_archived_published, @pub_child_of_archived_published, @arc_plan_child_of_archived_published, @arc_pub_child_of_archived_published].map(&:id).sort)
      end
    end

    context 'when all but archived' do
      it 'must not only return active schematics' do
        result = Schematic.by_status([0,1]).pluck(:id).sort
        expect(Schematic.by_status(['planning','published']).pluck(:id).sort).to eq(result)
        expect(result).to eq([@planning_schematic, @plan_child_of_planning, @arc_plan_child_of_planning, @plan_child_of_published, @arc_plan_child_of_published, @published_schematic, @pub_child_of_published, @arc_pub_child_of_planning, @pub_child_of_planning, @arc_pub_child_of_published].map(&:id).sort)
      end
    end

    context 'when all types' do
      it 'must not only return active schematics' do
        result = Schematic.by_status([0,1,2]).pluck(:id).sort
        expect(Schematic.by_status(['planning','published', 'archived']).pluck(:id).sort).to eq(result)
        expect(result).to eq([@planning_schematic, @plan_child_of_planning, @arc_plan_child_of_planning, @plan_child_of_published, @arc_plan_child_of_published, @published_schematic, @pub_child_of_published, @arc_pub_child_of_planning, @pub_child_of_planning, @arc_pub_child_of_published, @archived_planning_schematic, @archived_published_schematic, @plan_child_of_archived_planning, @pub_child_of_archived_planning, @arc_plan_child_of_archived_planning, @arc_pub_child_of_archived_planning, @plan_child_of_archived_published, @pub_child_of_archived_published, @arc_plan_child_of_archived_published, @arc_pub_child_of_archived_published].map(&:id).sort)
      end
    end

    context 'when no types' do
      it 'must not only return active schematics' do
        result = Schematic.by_status([]).order(:id)
        expect(Schematic.by_status([]).order(:id)).to eq(result)
        expect(result).to eq([].sort_by(&:id))
      end
    end
  end
end
