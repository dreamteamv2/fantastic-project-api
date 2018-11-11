# frozen_string_literal: true

module FantasticProject
  module PredictHQ
    # Gives access to the data
    class EventMapper
      def initialize(token, gateway_class = FantasticProject::PredictHQ::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(params)
        @gateway.search_events(params).map do |data|
          DataMapper.new(data).build_entity
        end
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
          title: title,
          description: description
        )
      end
       private
       def origin_id
        @data['id']
      end
       def title
        @event_data['title']
      end
       def description
        @event_data['description']
      end
    end
  end
end