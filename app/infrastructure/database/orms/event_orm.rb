# frozen_string_literal: true

require 'sequel'

# Database module
module FantasticProject
  # Databbase module for events entities
  module Database
    # Object Relational Mapper for Event Entities
    class EventOrm < Sequel::Model(:events)
      plugin :timestamps, update_on_create: true
    end

    def self.find_or_create(event_info)
      first(origin_id: event_info[:origin_id]) || create(event_info)
    end
  end
end
