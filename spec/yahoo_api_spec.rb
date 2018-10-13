# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/weather/yahoo_api'

describe 'Test fantastic library' do
  CITY = 'Taipei City'
  CORRECT = YAML.safe_load(File.read('spec/fixtures/yahoo_results.yml'))

  describe 'Weather information' do
    it 'HAPPY: should provide correct weather data' do
      weather_data = FantasticProject::YahooAPI.new
                                               .weather(CITY)
      _(weather_data.name).must_equal CORRECT['query']['results']['channel']['location']['city']
      _(weather_data.link).must_equal CORRECT['query']['results']['channel']['link']
    end
  end

  describe 'City information' do
    before do
      @city = FantasticProject::YahooAPI.new
                                        .weather(CITY)
    end

    it 'HAPPY: should be the same city' do
      _(@city.name).must_equal CITY
    end

    it 'HAPPY: should has forecast' do
      _(@city.forecast).wont_be_nil
    end
  end
end
