# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'image_representer'

# Represents essential Repo information for API output
module FantasticProject
  module Representer
    # Represent a Project entity as Json
    class Event < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :origin_id
      property :country_code
      property :category
      property :title
      property :description

      private

      def event_name
        represented.name
      end

      def country_code
        represented.country_code
      end
    end
  end
end
