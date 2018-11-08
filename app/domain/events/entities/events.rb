# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FantasticProject
  module Entity
    # Domain entity for any event
    class Event < Dry::Struct
      include Dry::Types.module

      attribute :id,          Integer.optional
      attribute :title,       Strict::String
      attribute :description, Strict::String
      attribute :category,    Strict::String
      attribute :labels,      Strict::String
    end
  end
end
