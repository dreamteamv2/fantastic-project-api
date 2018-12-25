# frozen_string_literal: true

# Represents essential Repo information for API output
module FantasticProject
  module Representer
    # Representer object for events requests
    class EventsRequest < Roar::Decorator
      include Roar::JSON

      property :country_code
      property :category
      property :id
    end
  end
end
