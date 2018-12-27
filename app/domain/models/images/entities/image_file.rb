# frozen_string_literal: true

require "dry-types"
require "dry-struct"

module FantasticProject
  module Entity
    # Country information
    class ImageFile < Dry::Struct
      include Dry::Types.module

      attribute :url, Strict::String
      attribute :origin_id, Strict::String
    end
  end
end
