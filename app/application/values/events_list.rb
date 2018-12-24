# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FantasticProject
  module Value
    # List of events
    EventsList = Struct.new(:events)
  end
end
