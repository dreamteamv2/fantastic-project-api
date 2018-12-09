# frozen_string_literal: true
require 'dry/monads/result'
module FantasticProject
 module Service
   # Retrieves array of all listed project entities
   # :reek:FeatureEnvy
   class EventList
     include Dry::Monads::Result::Mixin
      def call(filters)
       events = Repository::For.klass(Entity::Event)
         .find_by_country_category(filters[:country], filters[:category])
        Success(events)
     end
   end
 end
end