# frozen_string_literal: true

module FantasticProject
    module Repository
      # Repository for Events
      class Events
        def self.find_id(id)
          rebuild_entity Database::EventOrm.first(id: id)
        end
        
        private
        
        def self.rebuild_entity(db_record)
          return nil unless db_record

          Entity::Event.new(
            id:        db_record.id,
            )
        end

        def self.rebuild_many(db_records)
          db_records.map do |db_member|
            Events.rebuild_entity(db_member)
        end

        end
         def self.db_find_or_create(entity)
          Database::EventOrm.find_or_create(entity.to_attr_hash)
        end
      end
    end
  end