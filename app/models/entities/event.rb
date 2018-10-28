# frozen_string_literal: false

module FantasticProject
  # Events class
  module Entity
    # Domain entity for any event
    class Event < Dry::Struct
      include Dry::Types.module

      attribute :id,          Integer.optional
      attribute :title,       Strict::String
      attribute :description, Strict::String
    end
  end
end
