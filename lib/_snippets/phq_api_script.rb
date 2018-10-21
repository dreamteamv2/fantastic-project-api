# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def phq_api_path(path)
  'https://api.predicthq.com/v1/' + path
end

def call_phq_url(config, url)
  HTTP.headers(
    'Accept' => 'application/json',
    'Authorization' => "Bearer #{config['PHQ_TOKEN']}"
  ).get(url)
end

phq_response = {}
phq_results = {}

events_url = phq_api_path('events/?country=TW')
phq_response[events_url] = call_phq_url(config, events_url)
events = phq_response[events_url].parse

phq_results['events'] = events

File.write('spec/fixtures/phq_response.yml', phq_response.to_yaml)
File.write('spec/fixtures/phq_results.yml', phq_results.to_yaml)
