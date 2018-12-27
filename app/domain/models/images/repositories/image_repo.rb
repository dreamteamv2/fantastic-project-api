# frozen_string_literal: true

# Image repo is responsible for get images
module FantasticProject
  module Repository
    # ImageRepo over local images
    class ImageRepo
      # Errors is responsible handler error
      class Errors
        # Errors is responsible handler error
        FolderNoFound = Class.new(StandardError)
      end

      def initialize(tag, config, files = nil)
        @files = files
        @local = Unsplash::ImagesManager.new(tag, config.IMAGE_PATH, @files)
      end

      def local
        exists_locally? ? @local : raise(Errors::FolderNoFound)
      end

      def local_images
        @local.local_images.map do |image|
          Entity::ImageFile.new(origin_id: '1', url: image.gsub!('public/', ''))
        end
      end

      def exists_locally?
        @local.exists?
      end

      def download_images
        @local.download_files
      end
    end
  end
end
