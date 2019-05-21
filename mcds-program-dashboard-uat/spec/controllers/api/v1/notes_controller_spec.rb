require 'rails_helper'

RSpec.describe Api::V1::NotesController, :type => :controller do
  describe "#index" do
    before(:each) do
      Schematic.any_instance.stub(:build_schematic)

      @document  = FactoryGirl.create(:document, :with_notes)
      @schematic = FactoryGirl.create(:schematic, status: 1, documents: [@document])
    end

    it "should return a 200" do
      get :index, format: :json, schematic_id: @schematic.id, document_id: @document.id

      expect(response.status).to eq(200)
    end

    it "should return a 200 when the schematic doesn't exist" do
      get :index, format: :json, schematic_id: 9999, document_id: 99999

      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    before(:each) do
      Schematic.any_instance.stub(:build_schematic)

      @document  = FactoryGirl.create(:document)
      @schematic = FactoryGirl.create(:schematic, status: 1, documents: [@document])
      @valid_note = FactoryGirl.build(:note)
    end

    it "should return a 422 when not is invalid" do
      post :create, format: :json, schematic_id: @schematic.id, document_id: @document.id, note: Note.new.as_json

      expect(response.status).to eq(422)
    end

    it "should return a 201 when valid" do
      post :create, format: :json, schematic_id: @schematic.id, document_id: @document.id, note: @valid_note.as_json

      expect(response.status).to eq(201)
    end

    it "should add a new note" do
      post :create, format: :json, schematic_id: @schematic.id, document_id: @document.id, note: @valid_note.as_json

      expect(response.status).to eq(201)
    end
  end

  describe "#update" do
    before(:each) do
      Schematic.any_instance.stub(:build_schematic)

      @document   = FactoryGirl.create(:document)
      @schematic  = FactoryGirl.create(:schematic, status: 1, documents: [@document])
      @valid_note = FactoryGirl.create(:note)
    end

    it "should return a 201 when valid" do
      @document.notes << @valid_note
      @valid_note.body = 'Special Ed Notes'

      put :update, format: :json, schematic_id: @schematic.id, document_id: @document.id, id: @valid_note.id, note: @valid_note.as_json

      expect(response.status).to eq(204)
    end
  end

  describe "#destroy" do
    before(:each) do
      Schematic.any_instance.stub(:build_schematic)

      @document   = FactoryGirl.create(:document)
      @schematic  = FactoryGirl.create(:schematic, status: 1, documents: [@document])
      @valid_note = FactoryGirl.create(:note)
    end

    it "should return a 201 when valid" do
      @document.notes << @valid_note
      @valid_note.body = 'Special Ed Notes'

      delete :destroy, format: :json, schematic_id: @schematic.id, document_id: @document.id, id: @valid_note.id, note: @valid_note.as_json

      expect(response.status).to eq(204)
    end
  end

end
