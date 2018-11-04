# frozen_string_literal: true
require 'sequel'

module FantasticProject
 module Database
   # Object Relational Mapper for Event Entities
   class EventOrm < Sequel::Model(:events)
      plugin :timestamps, update_on_create: true
   end
 end
end