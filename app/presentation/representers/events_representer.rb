# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'event_representer'

module FantasticProject
  module Representer
    # Represents list of projects for API output
    class EventsList < Roar::Decorator
      include Roar::JSON

      collection :events, extend: Representer::Event
    end
  end
end
