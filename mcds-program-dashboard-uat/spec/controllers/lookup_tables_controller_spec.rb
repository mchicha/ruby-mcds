
require 'rails_helper'

describe LookupTablesController do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: :tukaiz_super_admin) }
  end

  subject { response }

  let!(:lookup_table) { create(:lookup_table) }
  let!(:lookup_table_row) { create(:lookup_table_row, lookup_table: lookup_table) }

  context 'as an authorized user' do

    describe '#index' do
      before { get :index}
      it { is_expected.to render_template(:index) }
      it "assigns all lookup_tables to @lookup_tables" do
        expect(assigns(:lookup_tables)).to eq([lookup_table])
      end
    end

    describe '#show' do
      before { get :show, id: lookup_table.id }
      it { is_expected.to render_template(:show) }
      it "assigns the correct lookup_table to @lookup_table" do
        expect(assigns(:lookup_table)).to eq(lookup_table)
      end
    end

    describe '#new' do
      before { get :new }
      it { is_expected.to render_template(:new) }
      it "assigns a new lookup_table to @lookup_table" do
        expect(assigns(:lookup_table)).to be_a_new(LookupTable)
      end
    end

    describe '#new_import' do
      before { get :new_import}
      it { is_expected.to render_template(:new_import) }
    end

    describe '#edit' do
      before { get :edit, id: lookup_table.id }
      it { is_expected.to render_template(:edit) }
      it "assigns the correct lookup_table to @lookup_table" do
        expect(assigns(:lookup_table)).to eq(lookup_table)
      end
    end

    describe '#update' do

      context "with valid attributes" do
        before { put :update, id: lookup_table.id, lookup_table: {key_field_name: 'sku'} }

        it "assigns the correct lookup_table to @lookup_table" do
          expect(assigns(:lookup_table)).to eq(lookup_table)
        end
        it "updates the lookup_table" do
          expect(lookup_table.reload.key_field_name).to eq('sku')
        end
        it { is_expected.to render_template(:show) }
      end

      context "with invalid attributes" do

        before { put :update, id: lookup_table.id, lookup_table: {key_field_name: nil} }
        it { is_expected.to render_template(:edit) }
        it "assigns the correct lookup_table to @lookup_table" do
          expect(assigns(:lookup_table)).to eq(lookup_table)
        end
        it "does not update the lookup_table" do
          expect(lookup_table.reload.key_field_name).to_not be_nil
        end
      end
    end

    describe '#create' do
      context "with valid attributes" do
        before { put :create, lookup_table: {key_field_name: 'totally_rad_new_name'} }

        it "creates a new lookup_table" do
          expect(LookupTable.where(key_field_name: 'totally_rad_new_name').length).to_not be_zero
        end
      end

      context "with invalid attributes" do
        before { put :create, lookup_table: {key_field_name: nil} }

        it { is_expected.to render_template(:new) }
        it "does not create a new lookup_table" do
          expect(LookupTable.where(key_field_name: nil).length).to be_zero
        end
      end
    end

    describe '#import' do
      context "running once for each spreadsheet" do
        let!(:friendly_sheet)  {
          ActionDispatch::Http::UploadedFile.new({
            :filename => 'CP Template and Friendly Names 6-17-15.xlsx',
            :type => 'text/xlsx',
            :tempfile => File.new("#{Rails.root}/spec/fixtures/import_spreadsheets/CP_Template_and_Friendly_Names_8-11-15.xlsx")
          })
        }

        let!(:position_sheets) {
           ActionDispatch::Http::UploadedFile.new({
            :filename => 'McSource_Online_Position_Labels_updated_6-17-15r.xlsx',
            :type => 'text/xlsx',
            :tempfile => File.new("#{Rails.root}/spec/fixtures/import_spreadsheets/McSource_Online_Position_Labels.xlsx")
          })
        }

        before { post :import, spreadsheet: friendly_sheet,  table_name:  'friendly', key_field_name: 'template_namez'}
        before { post :import, spreadsheet: position_sheets, table_name:  'position', key_field_name: 'template_namez'}

        it "creates two new lookup_tables" do
          expect(LookupTable.where(key_field_name: 'template_namez').length).to eq(2)
        end

        it "creates proper amount of lookup_table_rows for the lookup table rows based on the spreadsheets" do
          friendly_keys = LookupTable.where(key_field_name: 'template_namez', table_name: 'friendly').first.lookup_table_rows.pluck(:key)
          position_keys = LookupTable.where(key_field_name: 'template_namez', table_name: 'position').first.lookup_table_rows.pluck(:key)

          expect(friendly_keys.length).to eq(102)
          expect(position_keys.length).to eq(106)

          expect(friendly_keys).to include('road_side_banner', 'graphic_readerboard_3x8', 'window_poster')
          expect(position_keys).to include('road_side_banner', 'graphic_readerboard_3x8', 'window_poster')

          expect(LookupTableRow.joins(:lookup_table).where(key: 'rooftop_banner', lookup_tables: {table_name: 'friendly'}).first.columns).to eq(
            {"Zone"=>"Exterior", "Element Name"=>"Rooftop Banner", "Size"=>"238 x 34"}
          )

          expect(LookupTableRow.joins(:lookup_table).where(key: 'rooftop_banner', lookup_tables: {table_name: 'position'}).first.columns).to eq(
            {"Position Name"=>"Rooftop Banner", "Position Ids"=>["1.3"]}
          )
        end
      end
    end
  end
end
