# frozen_string_literal: false

require 'http'
require 'cgi'

module FantasticProject
  module PredictHQ
    # Library for PredictHQ Web API
    class Api
      def initialize(token)
        @phq_token = token
      end

      def search_events(params)
        Request.new(@phq_token).event(params).parse['results']
      end

      # Sends out HTTP requests to PredictHQ
      class Request
        API_PATH = 'https://api.predicthq.com/v1/'.freeze
        EVENT_ENDPOINT = 'events/?'.freeze

        def initialize(token)
          @token = token
        end

        def event(params)
          query = CGI.unescape(URI.encode_www_form(params))
          get(API_PATH + EVENT_ENDPOINT + query)
        end

        def get(url)
          http_response = HTTP.headers(
            'Accept' => 'application/json',
            'Authorization' => "Bearer #{@token}"
          ).get(url)

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
          404 => NotFound
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
