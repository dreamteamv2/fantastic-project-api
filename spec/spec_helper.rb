# frozen_string_literal: false

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init.rb'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
PHQ_TOKEN = CONFIG['PHQ_TOKEN']
PHQ_CLIENT_ID = CONFIG['PHQ_CLIENT_ID']
PHQ_SECRET_KEY = CONFIG['PHQ_SECRET_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/phq_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'phq_api'.freeze
