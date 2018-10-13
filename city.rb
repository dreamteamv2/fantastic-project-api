# frozen_string_literal: false

module FantasticProject
  # Provides access to forecast data
  class City
    def initialize(city_data)
      @city_data = city_data
    end

    def forecast
      @city_data['query']['results']['channel']['item']
    end

    def name
      @city_data['query']['results']['channel']['location']['city']
    end

    def link
      @city_data['query']['results']['channel']['link']
    end
  end
end
