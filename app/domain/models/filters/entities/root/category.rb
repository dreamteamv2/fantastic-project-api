# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FantasticProject
  module Entity
    # Country information
    class Category < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :title, Strict::String
      attribute :description, Strict::String
    end
  end
end
