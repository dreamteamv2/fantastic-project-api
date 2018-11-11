# frozen_string_literal: true

require 'roda'
require 'slim'

module FantasticProject
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row.js'    
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # POST /
      routing.root do
        view 'home'
        # projects = Repository::For.klass(Entity::Project).all
        # view 'home', locals: { projects: projects }
      end

      routing.on 'events' do
        routing.is do
          # GET /event/
          routing.post do
            city = routing.params['city']
            routing.redirect "events/#{city}"
          end
        end

        routing.on String do |city|
          # GET /event/city
          routing.get do
            events = PredictHQ::EventMapper
              .new(App.config.PHQ_TOKEN)
              .find(country: city)

            view 'events', locals: { city: city, events: events }
          end
        end
      end
    end
  end
end
