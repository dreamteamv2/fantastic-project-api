#Creating File Weather Info

require 'http'
require 'yaml'
require 'cgi'

#config = YAML.safe_load(File.read('config/secrets.yml'))

def yh_api_path(city)
    yh_url = 'https://query.yahooapis.com/v1/public/yql?q='
    query = 'select * from weather.forecast where woeid'\
            " in (select woeid from geo.places(1) where text=\"#{city}\")"
    format_request = '&format=json'
    yh_url + CGI.escape(query) + format_request
end

def call_yh_url(url)
    HTTP.get(url)
end

yh_results = {}

## Save Results

city_url = yh_api_path('Taipei')
yh_results = call_yh_url(city_url)
city = yh_results.parse

File.write('spec/fixtures/yahoo_results.yml', city.to_yaml)