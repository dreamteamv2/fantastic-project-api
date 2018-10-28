# frozen_string_literal: false

module FantasticProject
    #Provides access to PredictHQ Data
  class EventMapper
    def initialize(gh_token, gateway_class = Github::Api)
      @token = gh_token
      @gateway_class = gateway_class
      @gateway = @gateway_class.new(@token)
    end
    
    def load_several(url)
      @gateway.contributors_data(url).map do |data|
        EventMapper.build_entity(data)
      end
    end
    
    def self.build_entity(data)
      DataMapper.new(data).build_entity
    end
    
    # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Event.new(
            id: nil,
            origin_id: origin_id,
            username: username
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