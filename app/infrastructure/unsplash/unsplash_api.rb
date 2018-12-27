# frozen_string_literal: false

require "http"
require "cgi"

module FantasticProject
  module Unsplash
    # Library for PredictHQ Web API
    class Api
      def initialize(client_id)
        @client_id = client_id
      end

      def search_images(params)
        Request.new(@client_id).query(params).parse["results"]
      end

      # Sends out HTTP requests to PredictHQ
      class Request
        API_PATH = "https://api.unsplash.com/".freeze

        def initialize(client_id)
          @client_id = client_id
          @event_endpoint = "/search/photos?client_id=#{@client_id}&"
        end

        def query(params)
          tag = {query: params}
          query = CGI.unescape(URI.encode_www_form(tag))
          get(API_PATH + @event_endpoint + query)
        end

        def get(url)
          http_response = HTTP.get(url)
          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Github with success/error
      class Response < SimpleDelegator
        # 401 Error
        Unauthorized = Class.new(StandardError)

        # 404 Error
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound,
        }.freeze

        def successful?
          HTTP_ERROR.key?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
