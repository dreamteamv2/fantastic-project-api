# frozen_string_literal: true
require 'dry/transaction'
module FantasticProject
 module Service
   # Transaction to store project from Github API to database
   class SearchCountry
     include Dry::Transaction
      step :check_country
     step :check_category
     step :find_events
     step :save_new_events
      private
      # :reek:NilCheck
     def check_country(input)
       if input.success?
         if (country_match = filter_country(input)).nil?
           Failure('Country not found')
         else
           Success(country: input[:country], cdata: country_match,
                   category: input[:category].downcase)
         end
       else
         Failure(input.errors.values.join('; '))
       end
     end
      def check_category(input)
       if filter_category(input).any?
         Success(input)
       else
         Failure('Category not found')
       end
     end
      def find_events(input)
       events = events_in_database(input)
        puts events
       if events.any?
         input[:local_events] = events
       else
         input[:remote_events] = events_from_phq(input)
       end
       Success(input)
     end
      def save_new_events(input)
       if (new_events = input[:remote_events])
         Repository::For.klass(Entity::Event).create_many(new_events)
       end
       Success(input)
     end
      # following are support methods that other services could use
      def filter_country(input)
       country = Mapper::CountriesMapper
         .new(App.config.COUNTRIES_FILE_PATH)
         .find(input[:country])
        country[0]
     rescue StandardError
       raise 'Could not find country repository'
     end
      def filter_category(input)
       Mapper::CagegoriesMapper
         .new(App.config.CATEGORIES_FILE_PATH)
         .find(input[:category])
     rescue StandardError
       raise 'Could not find category repository'
     end
      def get_events(input)
       local_events = events_in_database(input)
       local_events.any? ? local_events : []
     end
      # :reek:UtilityFunction
     def events_from_phq(input)
       params = {
         country: input[:cdata].alpha2,
         category: input[:category].downcase
       }
       PredictHQ::EventMapper
         .new(App.config.PHQ_TOKEN)
         .find(params)
     end
      # :reek:UtilityFunction
     def events_in_database(input)
       Repository::For.klass(Entity::Event)
         .find_by_country_category(input[:cdata].alpha2, input[:category])
     end
   end
 end
end