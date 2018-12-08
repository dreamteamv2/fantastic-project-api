# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module FantasticProject
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'

    use Rack::MethodOverride 

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
