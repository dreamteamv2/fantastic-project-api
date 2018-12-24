# frozen_string_literal: true

module FantasticProject
  module RouteHelpers
    # Application value for the path of a requested project
    class EventRequestPath
      def initialize(category, country)
        @category = category
        @country = country
      end

      attr_reader :category, :country
    end
  end
end
