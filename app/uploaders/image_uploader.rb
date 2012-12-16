# encoding: utf-8


class ImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :thumb do
      process :resize_to_fill => [200, 200]
    end
  
    version :medium do
      process :resize_to_limit => [400, 400]
    end

  
end
