#Creating File Project Info

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def yahoo_api_path(path)
    'https://developer.yahoo.com/' + path
end

def call_yahoo_url(config, url)
    HTTP.headers(
        'Accept' => 
        'Authorization' => 
    )
end