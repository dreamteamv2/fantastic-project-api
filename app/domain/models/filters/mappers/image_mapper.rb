# frozen_string_literal: true

module FantasticProject
  module Mapper
    # Summarizes contributions for an entire folder
    class ImageFileMapper
      attr_reader :folder_name

      def initialize(city, gateway_class)
        @city = city
        @gateway_class = gateway_class
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      def load_data
        @gateway_class.loadImages.map do |data|
          ImageFileMapper.build_entity(data)
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Category.new(
            id: nil,
            origin_id: origin_id,
            description: description,
            file: file,
            url: url
          )
        end

        private

        def origin_id
          @data['origin_id']
        end

        def description
          @data['description']
        end

        def file
          @data['file']
        end

        def url
          @data['url']
        end
      end
    end
  end
end
