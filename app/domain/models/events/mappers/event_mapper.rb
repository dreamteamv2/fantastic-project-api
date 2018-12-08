# frozen_string_literal: true

module FantasticProject
  module PredictHQ
    # Gives access to the data
    class EventMapper
      def initialize(token, gateway_class = FantasticProject::PredictHQ::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
        @events = []
      end

      def find(params)
        @events = @gateway.search_events(params)
        clean_events.map do |data|
          DataMapper.new(data).build_entity
        end
      end

      def clean_events
        @events.nil? ? [] : @events
      end
    end

    # extrats entity specific elements from data structure
    class DataMapper
      def initialize(data)
        @event_data = data
      end

      def build_entity
        Entity::Event.new(
          id: nil,
          origin_id: origin_id,
          title: title,
          country_code: country,
          category: category,
          description: description
        )
      end

      private

      def origin_id
        @event_data['id']
      end

      def title
        @event_data['title']
      end

      def category
        @event_data['category']
      end

      def country
        @event_data['country']
      end

      def description
        @event_data['description']
      end
    end
  end
end
