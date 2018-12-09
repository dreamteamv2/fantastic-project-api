# frozen_string_literal: true
require 'dry-validation'
module FantasticProject
 module Forms
   CountrySearch = Dry::Validation.Params do
     required(:country).filled
     required(:category).filled
      configure do
       config.messages_file = File.join(__dir__, 'errors/country_request.yml')
     end
   end
 end
end