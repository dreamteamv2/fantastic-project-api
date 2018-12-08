# frozen_string_literal: true

module FantasticProject
  module Repository
    # Repository events
    class Events
      def self.all
        Database::EventOrm.all.map { |db_event| rebuild_entity(db_event) }
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Event.new(
          id: db_record.id,
          origin_id: db_record.origin_id,
          country_code: db_record.country_code,
          category: db_record.category,
          title: db_record.title,
          description: db_record.description
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |event|
          rebuild_entity(event)
        end
      end

      def self.create_many(entities)
        entities.map do |event|
          find_or_create(event)
        end
      end

      def self.find_or_create(entity)
        Database::EventOrm.find_or_create(entity.to_attr_hash)
      end

      def self.find_by_country_category(country, category)
        now = DateTime.now
        beginning_of_day = DateTime.new(now.year,
                                        now.month,
                                        now.day, 0, 0, 0, now.zone)

        db_records = Database::EventOrm
          .where(country_code: country, category: category)
          .where { created_at > beginning_of_day }

        rebuild_many(db_records)
      end
    end
  end
end
