# frozen_string_literal: false

module FantasticProject
  # Provides access to PredictHQ Data
  class EventMapper
    def initialize(token, gateway_class = PredictHQAPI::Api)
      @token = token
      @gateway_class = gateway_class
      @gateway = @gateway_class.new(@token)
    end

    def find(params)
      data = @gateway.search_events(params)
      build_entity(data)
    end

    def build_entity(data)
      DataMapper.new(data, @token, @gateway_class).build_entity
    end

    # Extracts entity specific elements from data structure
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        Entity::Event.new(
          id: nil,
          title: title,
          description: description
        )
      end

      private

      def title
        @event_data['title']
      end

      def description
        @event_data['description']
      end
    end
  end
end
