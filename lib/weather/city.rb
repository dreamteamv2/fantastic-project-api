# frozen_string_literal: false

module FantasticProject
  # Provides access to forecast data
  class Country
    def initialize(country_data)
      @country_data = country_data
    end

    def forecast
      @country_data['results']['forecast']
    end
  end
end
