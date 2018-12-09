# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../../init.rb'

CATEGORY='sports'
COUNTRY='argentina'
GITHUB_TOKEN = CodePraise::App.config.PHQ_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/phq_results.yml'))

# Helper methods
def homepage
  CodePraise::App.config.APP_HOST
end