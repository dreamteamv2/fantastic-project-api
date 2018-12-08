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

        Entity::Event.new(
          id: db_record.id,
          title: db_record.title,
          description: db_record.description
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |event|
          Events.rebuild_entity(event)
        end
      end

      def self.db_find_or_create(entity)
        Database::EventOrm.db_find_or_create(entity.to_attr_hash)
      end
    end
  end
end
