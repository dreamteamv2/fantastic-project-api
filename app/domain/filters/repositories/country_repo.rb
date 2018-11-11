# frozen_string_literal: true

module FantasticProject
  # Maps over local country file
  class CountryRepo
    MAX_SIZE = 1000 # for cloning, analysis, summaries, etc.

    class Errors
      NotFileFoundend = Class.new(StandardError)
    end