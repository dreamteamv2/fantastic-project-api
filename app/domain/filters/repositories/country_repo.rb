# frozen_string_literal: true

module FantasticProject
  # Maps over local country file
  class CountryRepo
    MAX_SIZE = 1000 # for cloning, analysis, summaries, etc.

    class Errors
      NotFileFoundend = Class.new(StandardError)
    end

    def initialize(config = FantasticProject::App.config)
      @countries = LocalData::File.new(config.COUNTRIES_FILE_PATH)
    end

    def countries
      raise Errors::NotFileFoundend unless exits_repo?

      @countries.to_hash
    end

    def exits_repo?
      @countries.exists?
    end
  end
end