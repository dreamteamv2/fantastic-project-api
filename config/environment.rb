# frozen_string_literal: true

require 'roda'
require 'yaml'

module FantasticProject
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    PHQ_TOKEN = CONFIG['PHQ_TOKEN']
  end
end
