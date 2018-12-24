# frozen_string_literal: true

require 'dry/monads/result'

module FantasticProject
  module Service
    # Retrieves array of all listed project entities
    # :reek:FeatureEnvy
    class EventList
      include Dry::Monads::Result::Mixin

      def call(filters)
        Repository::For.klass(Entity::Event)
          .find_by_country_category(filters[:country], filters[:category])
          .then { |events| Value::EventsList.new(events) }
          .then do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end

        Success(Value::Result.new(status: :ok, message: events))
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error,
                                  message: 'Cannot access database'))
      end
    end
  end
end
