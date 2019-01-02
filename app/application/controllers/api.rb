# frozen_string_literal: true

require 'roda'
require_relative 'lib/init'

module FantasticProject
  # Web Api
  class Api < Roda
    plugin :halt
    plugin :all_verbs
    plugin :caching
    use Rack::MethodOverride

    plugin :public, root: './public'

    route do |routing|
      routing.public
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "Eventix API v1 at /api/v1/ in #{Api.environment} mode"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'events' do
          routing.on String, String do |category, country|
            # GET /events/{category}/{country}
            routing.get do
              Cache::Control.new(response).turn_on if Env.new(Api).production?

              result = Service::EventList.new.call(
                country: country,
                category: category
              )
              Representer::For.new(result).status_and_body(response)
            end
          end

          routing.on Integer do |id|
            # GET /events/{id}
            routing.get do
              request_id = [request.env, request.path, Time.now.to_f].hash
              result = Service::Event.new.call(
                id: id,
                request_id: request_id
              )
              Representer::For.new(result).status_and_body(response)
            end
          end
        end
      end
    end
  end
end
