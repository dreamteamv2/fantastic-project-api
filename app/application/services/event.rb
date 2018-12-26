# frozen_string_literal: true

require "dry/transaction"

module FantasticProject
  module Service
    # Transaction to store project from Github API to database
    class Event
      include Dry::Transaction

      step :check_event
      step :request_images

      private

      GET_INFO_ERR = "Could not find the event"
      NO_EVENT_ERR = "Event not found"
      DB_ERR = "Having trouble accessing the database"

      # :reek:NilCheck
      def check_event(input)
        input[:event] = Repository::For.klass(Entity::Event).find_id(
          id: input[:id],
        )

        if input[:event]
          Success(input)
        else
          Failure(Value::Result.new(status: :not_found, message: NO_EVENT_ERR))
        end
      end

      def request_images(input)
        Messaging::Queue.new(Api.config.GET_INFO_QUEUE_URL, Api.config)
          .send(get_info_request_json(input))

        Failure(
          Value::Result.new(status: :processing,
                            message: {request_id: input[:request_id]})
        )
      end

      # Utility function

      def get_info_request_json(input)
        Value::GetInfoRequest.new(input[:event],
                                  input[:request_id])
          .yield_self { |request| Representer::EventsRequest.new(request) }
          .yield_self(&:to_json)
      end
    end
  end
end
