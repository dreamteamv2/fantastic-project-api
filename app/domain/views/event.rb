# frozen_string_literal: true

module Views
  # View for a single event entity
  class Event
    def initialize(event, index = nil)
      @event = event
      @index = index
    end

    def entity
      @event
    end

    def title
      @event.title
    end

    def country
      @event.country_code
    end

    # rubocop:disable Metrics/LineLength
    # :reek:DuplicateMethodCall
    def description
      if @event.description == ''
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      else
        @event.description
      end
    end
    # rubocop:enable Metrics/LineLength
  end
end
