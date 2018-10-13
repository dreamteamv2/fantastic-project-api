require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative 'lib/weather/yahoo-api'

describe 'Test fantastic library'
    CITY = 'Taipei'.freeze
    forecast_temp = '39'.freeze

    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    YH_TOKEN = CONFIG['YH_TOKEN']

    CORRECT = YAML.safe_load(File.read('spec/fixtures/yahoo_response.yml'))
    RESPONSE = YAML.load(File.read('spec/fixtures/yahoo_response'))

    describe 'Weather information' do
        it 'HAPPY: should provide correct weather data' do
            weather_data = FantasticProject::yahoo-api.new(YH_TOKEN)
                                               .weather_data(CITY, forecast_temp)
            _(weather_data.CITY).must_equal CORRECT['CITY']
            _(weather_data.0:forecast:temp).must_equal CORRECT['0:forecast:temp']   
        end

        it 'SAD: should raise exception on incorrect project' do 
            weather do 
                FantasticProject::yahoo-api.new(YH_TOKEN).weather_data('')