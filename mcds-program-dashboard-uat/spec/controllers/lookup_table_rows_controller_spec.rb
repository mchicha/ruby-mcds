require 'rails_helper'
WebMock.disable_net_connect!(:allow_localhost => true)
describe LookupTableRowsController do
  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: :tukaiz_super_admin) }
  end

  subject { response }

  let!(:lookup_table) { create(:lookup_table) }
  let!(:lookup_table_row) { create(:lookup_table_row, lookup_table: lookup_table) }

  context 'as an authorized user' do

    describe '#index' do
      before { get :index, lookup_table_id: lookup_table.id }
      it { is_expected.to render_template(:index) }
      it "assigns lookup_table to @lookup_table" do expect(assigns(:lookup_table)).to eq(lookup_table) end
      it "assigns all lookup_table_rows from the lookup_table to @lookup_tables" do expect(assigns(:lookup_table_rows)).to eq(lookup_table.lookup_table_rows) end
    end

    describe '#show' do
      before { get :show, lookup_table_id: lookup_table.id, id: lookup_table_row.id }
      it { is_expected.to render_template(:show) }
      it "assigns the correct lookup_table_row to @lookup_table_row" do expect(assigns(:lookup_table_row)).to eq(lookup_table_row) end
    end

    describe '#new' do
      before { get :new, lookup_table_id: lookup_table.id, id: lookup_table_row.id }
      it { is_expected.to render_template(:new) }
      it "assigns a new lookup_table_row to @lookup_table_row" do expect(assigns(:lookup_table_row)).to be_a_new(LookupTableRow) end
    end

    describe '#edit' do
      before { get :edit, lookup_table_id: lookup_table.id, id: lookup_table_row.id }
      it { is_expected.to render_template(:edit) }
      it "assigns the correct lookup_table_row to @lookup_table_row" do expect(assigns(:lookup_table_row)).to eq(lookup_table_row) end
    end

    describe '#update' do

      context "with valid attributes" do
        before { put :update, lookup_table_id: lookup_table.id, id: lookup_table_row.id, lookup_table_row: {key: 'cheese_is_delicious'} }

        it "assigns the correct lookup_table_row to @lookup_table_row" do expect(assigns(:lookup_table_row)).to eq(lookup_table_row) end
        it "updates the lookup_table_row" do expect(lookup_table_row.reload.key).to eq('cheese_is_delicious') end
        it { is_expected.to render_template(:show) }
      end

      context "with invalid attributes" do

        before { put :update, lookup_table_id: lookup_table.id, id: lookup_table_row.id, lookup_table_row: {key: nil} }
        it { is_expected.to render_template(:edit) }
        it "assigns the correct lookup_table_row to @lookup_table_row" do expect(assigns(:lookup_table_row)).to eq(lookup_table_row) end
        it "does not update the lookup_table_row" do expect(lookup_table_row.reload.lookup_table_id).to_not eq(90001) end
      end
    end

    describe '#create' do

      context "with valid attributes" do

        before { put :create, lookup_table_id: lookup_table.id, lookup_table_row: {key: 'totally_rad_new_name'} }

        it "creates a new lookup_table" do expect(LookupTableRow.where(key: 'totally_rad_new_name').length).to_not be_zero end
      end

      context "with invalid attributes" do
        before { put :create, lookup_table_id: lookup_table.id, lookup_table_row: {key: nil, lookup_table_id: 90001} }

        it { is_expected.to render_template(:new) }
        it "does not create a new lookup_table" do expect(LookupTableRow.where(lookup_table_id: 90001).length).to be_zero end
      end
    end
  end

  context 'as an admin' do

  end

  context 'as a user' do

  end

end
