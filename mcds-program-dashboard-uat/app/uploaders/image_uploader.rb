# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  def store_dir
    "uploads/#{mounted_as}/#{model.schematic_id}"
  end

  def cache_dir
    '/tmp'
  end

  def extension_white_list
     %w(pdf)
  end


end
