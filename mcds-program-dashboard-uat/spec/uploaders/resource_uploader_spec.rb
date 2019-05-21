require "carrierwave/test/matchers"

describe ResourceUploader do
  include CarrierWave::Test::Matchers

  before do
    @resource = FactoryGirl.create(:resource)
    ResourceUploader.enable_processing = true
    @uploader = ResourceUploader.new(@resource, :file)
    @uploader.store!(@resource.file)
  end

  after do
    ResourceUploader.enable_processing = false
    @uploader.remove!
  end

  it "should be an object" do
    expect(@uploader).to be_a(Object)
  end

  it "should have appropriate permissions" do
    expect(@uploader).to have_permissions(0666)
  end

  it "should have the dimensions of 500x500" do
    expect(@uploader).to have_dimensions(500, 500)
  end

end
