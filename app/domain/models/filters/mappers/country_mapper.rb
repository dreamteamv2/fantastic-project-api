# frozen_string_literal: true

module FantasticProject
  module Mapper
    # Summarizes a single file's contributions by team members

    # :reek:UncommunicativeMethodName
    class CountriesMapper
      attr_reader :name
      attr_reader :alpha2
      attr_reader :country_code

      def initialize(file, local_data_class = LocalData::JsonFile)
        @file = file
        @local_data_class = local_data_class.new(file)
        @data = load_data
      end

      def load_data
        @local_data_class.to_hash.map do |data|
          CountriesMapper.build_entity(data)
        end
      end

      def find(filter)
        @data.select { |country| country.name.casecmp(filter.strip).zero? }
      end

      def find_by_code(filter)
        @data.select { |country| country.alpha2.casecmp(filter.strip).zero? }
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Country.new(
            id: nil,
            name: name,
            alpha2: alpha2,
            country_code: country_code,
          )
        end

        private

        def name
          @data["name"]
        end

        def alpha2
          @data["alpha-2"]
        end

        def country_code
          @data["country-code"]
        end
      end
    end
  end
end
