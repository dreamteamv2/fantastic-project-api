# frozen_string_literal: true

module FantasticProject
  module Mapper
    # Summarizes contributions for an entire folder
    class ImageFileMapper
      attr_reader :folder_name

      def initialize(query, client_id, gateway_class = Unsplash::Api)
        @query = query
        @gateway_class = gateway_class.new(client_id)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      def load_data
        @gateway_class.search_images(@query).map do |data|
          ImageFileMapper.build_entity(data)
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::ImageFile.new(
            id: nil,
            origin_id: origin_id,
            url: url,
          )
        end

        private

        def origin_id
          @data["id"]
        end

        def url
          @data["links"]["download"]
        end
      end
    end
  end
end
