# frozen_string_literal: true

module FantasticProject
  module Mapper
    # Summarizes categories
    class CagegoriesMapper
      attr_reader :title
      attr_reader :description

      def initialize(file, local_data_class = LocalData::JsonFile)
        @file = file
        @local_data_class = local_data_class.new(file)
        @data = load_data
      end

      def load_data
        @local_data_class.to_hash.map do |data|
          CagegoriesMapper.build_entity(data)
        end
      end

      def find(filter)
        @data.select { |category| category.title.casecmp(filter.strip).zero? }
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
          Entity::Category.new(
            id: nil,
            title: title,
            description: description
          )
        end

        private

        def title
          @data['title']
        end

        def description
          @data['description']
        end
      end
    end
  end
end
