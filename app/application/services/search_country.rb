# frozen_string_literal: true

require "dry/transaction"

module FantasticProject
  module Service
    # Transaction to store project from Github API to database
    class SearchCountry
      include Dry::Transaction

      step :check_country
      step :check_category
      step :find_events
      step :save_new_events
      step :events_list

      private

      GET_INFO_ERR = "Could not find the events using the parameters"

      # :reek:NilCheck
      def check_country(input)
        country_data = filter_country(input)
        if !country_data.nil?
          Success(country: input[:country],
                  cdata: country_data,
                  category: input[:category].downcase,
                  request_id: input[:request_id])
        else
          Failure(Value::Result.new(status: :internal_error, message: GET_INFO_ERR))
        end
      end

      def check_category(input)
        if filter_category(input).any?
          Success(input)
        else
          Failure(Value::Result.new(status: :internal_error, message: GET_INFO_ERR))
        end
      end

      def find_events(input)
        events = events_in_database(input)
        if events.any?
          input[:local_events] = events
        else
          input[:remote_events] = events_from_phq(input)
        end
        Success(input)
      end

      def save_new_events(input)
        if (new_events = input[:remote_events])
          Repository::For.klass(Entity::Event).create_many(new_events)
        end
        Success(input)
      end

      def events_list(input)
        Repository::For.klass(Entity::Event)
          .find_by_country_category(input[:cdata].alpha2, input[:category].downcase)
          .yield_self { |events| Value::EventsList.new(events) }
          .yield_self do |list|
          Success(Value::Result.new(status: :ok, message: list))
        end
      end

      # following are support methods that other services could use

      def filter_country(input)
        country = Mapper::CountriesMapper
          .new(Api.config.COUNTRIES_FILE_PATH)
          .find(input[:country])
        country[0]
      rescue StandardError
        raise "Could not find country repository"
      end

      def filter_category(input)
        Mapper::CagegoriesMapper
          .new(Api.config.CATEGORIES_FILE_PATH)
          .find(input[:category])
      rescue StandardError
        raise "Could not find category repository"
      end

      # Utility functions

      # :reek:UtilityFunction
      def events_from_phq(input)
        params = {
          country: input[:cdata].alpha2,
          category: input[:category].downcase,
        }
        PredictHQ::EventMapper
          .new(Api.config.PHQ_TOKEN)
          .find(params)
      end

      def events_in_database(input)
        Repository::For.klass(Entity::Event)
          .find_by_country_category(input[:cdata].alpha2, input[:category])
      end

      # :reek:UtilityFunction
    end
  end
end

=begin
      def get_info_request_json(input)
        Value::GetInfoRequest.new(input[:cdata].alpha2,
                                  input[:category].downcase,
                                  input[:request_id])
          .yield_self { |request| Representer::EventsRequest.new(request) }
          .yield_self(&:to_json)
      end

  Messaging::Queue.new(Api.config.GET_INFO_QUEUE_URL, Api.config)
            .send(get_info_request_json(input))

          Failure(
            Value::Result.new(status: :processing,
                              message: {request_id: input[:request_id]})
          )
=end
