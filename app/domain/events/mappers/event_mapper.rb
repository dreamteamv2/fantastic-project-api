# frozen_string_literal: false

module FantasticProject
    module PredictHQ
        # Gives access to the data
        class EventMapper
            def initialize(token, gateway_class = PredictHQ::API)
                @token = token
                @gateway_class = gateway_class
                @gateway = @gateway_class.new(@token)
            end

            def find(params)
                @gateway.search_events(params).map do |data|
                    DataMapper.new(data).build_entity
                end
            end

            # extrats entity specific elements from data structure
            class DataMapper
                def initialize(data)
                    @event_data = data
                end

                def build entity
                    Entity::Event.new(
                        id: nil,
                        title: title
                        description: description
                        category: category
                        labels: labels
                    )
                    end

                    private

                    def title
                        @event_data['title']
                    end

                    def description
                        @event_data['description']
                    end

                    def description
                        @event_data['category']
                    end

                    def description
                        @event_data['labels']
                    end
                end
            end
        end
    end
