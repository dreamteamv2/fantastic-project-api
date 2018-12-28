# frozen_string_literal: true

require 'dry/transaction'

module FantasticProject
  module Service
    # Transaction to store project from Github API to database

    # :reek:DuplicateMethodCall
    # :reek:FeatureEnvy
    # :reek:UtilityFunction
    class Event
      include Dry::Transaction

      step :check_event
      step :request_images
      step :event_info

      private

      GET_INFO_ERR = 'Could not find the event'
      NO_EVENT_ERR = 'Event not found'
      DB_ERR = 'Having trouble accessing the database'

      # :reek:NilCheck
      def check_event(input)
        input[:event] = Repository::For.klass(Entity::Event).find_id(
          id: input[:id]
        )

        if input[:event]
          Success(input)
        else
          Failure(Value::Result.new(status: :not_found, message: NO_EVENT_ERR))
        end
      end

      # rubocop:disable Metrics/AbcSize
      def request_images(input)
        input[:country] = filter_country(input)

        if Repository::ImageRepo.new(input[:country].name, Api.config)
            .s3_exists?
          Success(input)
        else
          Messaging::Queue.new(Api.config.GET_INFO_QUEUE_URL, Api.config)
            .send(get_info_request_json(input))

          Failure(Value::Result.new(status: :processing,
                                    message: { request_id: input[:request_id] }))
        end
      end
      # rubocop:enable Metrics/AbcSize

      def event_info(input)
        images = s3_images(input)
        Value::FullEvent.new(input[:event], images)
          .yield_self do |data|
          Success(Value::Result.new(status: :ok, message: data))
        end
      end

      # Utility function

      def filter_country(input)
        country = Mapper::CountriesMapper
          .new(Api.config.COUNTRIES_FILE_PATH)
          .find_by_code(input[:event].country_code)
        country[0]
      rescue StandardError
        raise 'Could not find country repository'
      end

      def get_info_request_json(input)
        Value::GetInfoRequest.new(input[:country].name,
                                  input[:request_id])
          .yield_self { |request| Representer::DownloadRequest.new(request) }
          .yield_self(&:to_json)
      end

      def local_images(input)
        Repository::ImageRepo.new(input[:country].name, Api.config)
          .local_images
      end

      def s3_images(input)
        Repository::ImageRepo.new(input[:country].name, Api.config)
          .s3_images
      end
    end
  end
end
