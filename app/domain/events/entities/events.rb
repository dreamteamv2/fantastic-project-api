# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FantasticProject
  module Entity
    # Domain entity any event
    class Event < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :title, Strict::String
      attribute :description, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key}
      end
    end
  end
end
