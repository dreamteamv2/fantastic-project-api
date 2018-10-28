# frozen_string_literal: true

require 'roda'
require 'slim'

module FantasticProject
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'events' do
        routing.is do
          # GET /event/
          routing.post do
            city = routing.params['city'].downcase
            routing.redirect "events/#{city}"
          end
        end

        routing.on String do |city|
          # GET /event/city
          routing.get do
            events = PredictHQ::EventMapper
              .new(TOKEN)
              .find(country: city)

            view 'events', locals: { city: city, events: events }
          end
        end
      end
    end
  end
end
