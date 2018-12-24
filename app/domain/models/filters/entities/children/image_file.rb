# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FantasticProject
  module Entity
    # Country information
    class ImageFile < Dry::Struct
      include Dry::Types.module

      attribute :origin_id, Strict::String
      attribute :description, Strict::String
      attribute :file, Strict::String
      attribute :url, Strict::String
    end
  end
end
