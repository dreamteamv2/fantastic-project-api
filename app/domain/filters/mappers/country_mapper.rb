# frozen_string_literal: true

module FantasticProject
  module Mapper
    # Summarizes a single file's contributions by team members
    class Countries
      def initialize(file)
        @file = file
    end

    def build_entity
      Entity::Countries.new(
        path: file_path,
        name: name,
      )
    end

    private

    def filename
        @file['name']
    end

    def countries
      get_countries(@file['file_path'])
    end

    def get_countries(objects)
      objects.map do |country|
        Entity::Country.new(
          name: country['name'],
          alpha2: country['alpha2'],
          country_code: country['country-code']
        )
      end
    end
  end
end
end