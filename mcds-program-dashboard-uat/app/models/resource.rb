class Resource < ActiveRecord::Base
  mount_uploader :file, ResourceUploader

  belongs_to :resourceable, polymorphic: true

  validates_presence_of :file
  validate :file_size_validation

  def file_size_validation
    errors[:file] << "Should be less than 50MB" if file.size > 50.megabytes
  end

end
