require 'http'
require_relative 'city.rb'

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

    def initialize(token, cache: {})
      @yahoo_token = token
      @cache = cache
    end

    def weather(city)
      weather_url = yh_api_path(city)
      call_yh_url(weather_url).parse
    end

    private

    def yh_api_path(path)
      yh_url = 'https://query.yahooapis.com/v1/public/yql?q='
      query = 'select * from weather.forecast where woeid'\
              " in (select woeid from geo.places(1) where text=#{path})"\
              '&format=json'
      CGI.escape(yh_url + query)
    end

    def call_yh_ulr(url)
      result = @cache.fetch(url) do
        HTTP.get(url)
      end
      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
