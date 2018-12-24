# frozen_string_literal: true

# Image repo is responsible for get the country info
module FantasticProject
  # ImageRepo over local and remote git repo infrastructure
  class ImageRepo
    MAX_SIZE = 1000 # for cloning, analysis, summaries, etc.

    # Errors is responsible handler error
    class Errors
      # Errors is responsible handler error
      ImageNoFound = Class.new(StandardError)
    end

    def initialize(image_id, config = CodePraise::App.config)
      @image_id = image_id
      @local = Image::LocalImage.new(image_id, config.IMAGEREPO_PATH)
    end

    def local
      exists_locally? ? @local : raise(Errors::ImageNoFound)
    end

    def exists_locally?
      @local.exists?
    end
  end
end
