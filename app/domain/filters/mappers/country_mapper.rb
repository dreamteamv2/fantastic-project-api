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