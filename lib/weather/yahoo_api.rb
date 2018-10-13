# frozen_string_literal: true

require 'http'
require 'cgi'
require_relative 'city'

module FantasticProject
  # Library Yahoo
  class YahooAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(cache: {})
      @cache = cache
    end

    def weather(city)
      weather_url = yh_api_path(city)
      weather_data = call_yh_url(weather_url).parse
      City.new(weather_data)
    end

    private

    def yh_api_path(path)
      yh_url = 'https://query.yahooapis.com/v1/public/yql?q='
      query = 'select * from weather.forecast where woeid'\
              " in (select woeid from geo.places(1) where text=\"#{path}\")"
      format_request = '&format=json'
      yh_url + CGI.escape(query) + format_request
    end

    def call_yh_url(url)
      result = @cache.fetch(url) do
        HTTP.get(url)
      end
      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.key?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
