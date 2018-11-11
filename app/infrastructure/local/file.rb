# frozen_string_literal: true

require 'json'

module FantasticProject
  module LocalData
    module Errors
      # Local repo not setup or invalid
      InvalidJson = Class.new(StandardError)
    end

    # Manage local file repository
    class File
      attr_reader :path

      def initialize(path)
        @path = path
        @json = File.read(@path)
      end

      def to_hash
        JSON.parse(@json)
      rescue JSON::ParserError
        false
      end

      def exists?
        Dir.exist? @path
      end
    end
  end
end