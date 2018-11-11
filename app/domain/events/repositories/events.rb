# frozen_string_literal: true

require_relative 'events.rb'

module FantasticProject
  module Repository
    # Repository events
    class Events
      def self.find_id(id)
        rebuild_entity Database::EventOrm.first(id: id)
      end

      def self.find_title(title)
        rebuild_entity Database::MemberOrm.first(title: title)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record
