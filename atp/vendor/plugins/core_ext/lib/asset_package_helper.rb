module ActionView
  module Helpers
    private
    def image_path(source)
      compute_public_path(source, 'images', nil)
    end
    alias_method :path_to_image, :image_path
  end
end