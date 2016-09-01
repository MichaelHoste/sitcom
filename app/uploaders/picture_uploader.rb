class PictureUploader < BasePublicUploader
  def extension_white_list
    %w(png jpg jpeg jpe)
  end

  version :preview do
    process :resize_to_fit => [200, 200]
  end
end
