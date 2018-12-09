# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require_relative 'helpers.rb'

module FantasticProject
  # Web App
  class App < Roda
    include RouteHelpers

    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets',
                    css: ['bootstrap.min.css', 'simple-line-icons.css',
                          'themify-icons.css', 'set1.css', 'style.css'],
                    js: ['jquery-3.2.1.min.js']

    plugin :public, root: './app/presentation/static'

    use Rack::MethodOverride

    route do |routing|
      routing.public
      routing.assets # load CSS

      # GET /
      routing.root do
        session[:watching] ||= []

=begin
     result = Service::EventList.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          view 'home', locals: { events: [] }
        end

        #events = result.value!
        flash.now[:notice] = 'Try to search Taiwan!' if events.none?

     events_searched = Views::EventList.new(events)
=end
        view 'home', locals: { events: [] }
      end

      routing.on 'events' do
        routing.is do
          # POST /event/
          routing.post do
            form_request = Forms::CountrySearch.call(routing.params)
            search_info = Service::SearchCountry.new.call(form_request)

            if search_info.failure?
              flash[:error] = search_info.failure
              routing.redirect '/'
            end

            search_info = search_info.value!
            cookie_data = {
              country: search_info[:country],
              category: search_info[:category]
            }

            session[:watching].insert(0, cookie_data).uniq!
            category = search_info[:category]
            country_code = search_info[:cdata].alpha2

            res_url = "events/#{category}/#{country_code}"
            routing.redirect res_url
          end
        end

        routing.on String, String do |category, country|
          # GET /events/{category}/{country}
          routing.get do
            path_request = EventRequestPath.new(
              category, country
            )
            session[:watching] ||= []

            result = Service::EventList.new.call(
              country: path_request.country,
              category: path_request.category
            )

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            events = result.value!
            events_data = Views::EventList.new(
              events
            )

            # Show events
            view 'events', locals: { events: events_data }
          end
        end
      end
    end
  end
end