# frozen_string_literal: true
require 'dry-types'
require 'dry-struct'
 module FantasticProject
  module Entity
    # Country information
    class Country < Dry::Struct
      include Dry::Types.module

      attribute :name, Strict::String
      attribute :alpha2, Strict::String
      attribute :country_code, Strict::String
    end
  end
end