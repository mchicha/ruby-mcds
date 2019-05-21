require 'rails_helper'

RSpec.describe ResourcesController, :type => :controller do

  before do
    @resource = FactoryGirl.create(:resource, :with_program)
  end

  describe "#create" do
    let(:new_file) { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/new_image.jpg'))) }

    before(:each) do
      @count = Resource.count
      post  :create,
            resource: { :file => new_file, :description => @resource.description },
            program_id: @resource.resourceable_id,
            format: :js
    end

    it 'should add a resource' do
      expect(Resource.count).to eq(@count + 1)
    end

    it 'should render create template' do
      expect(response).to render_template(:create)
      expect(response).to be_success
    end

  end

  describe "#update" do
    let(:new_file) { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/new_image.jpg'))) }

    before(:each) do
      post  :update,
            id: @resource.id,
            program_id: @resource.resourceable_id,
            format: :js,
            resource: { :description => "New Description", :file => new_file }
      @resource.reload
    end

    it 'should update the resource description' do
      expect(@resource.description).to eq("New Description")
    end

    it 'should update the resource file' do
      file_name = @resource.file.url.split('/').last
      expect(file_name).to eq('new_image.jpg')
    end

    it 'should render update template' do
      expect(response).to render_template(:update)
      expect(response).to be_success
    end


  end

  describe "#destroy" do

    it 'should delete the record' do
      delete :destroy, id: @resource.id, program_id: @resource.resourceable_id, format: :js
      expect(@resource.resourceable.resources).to be_empty
    end

  end

end
