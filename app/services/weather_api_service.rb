require 'net/http'

# Wrapper service for fetching forecasts from the WeatherAPI https://www.weatherapi.com
class WeatherApiService
  FORECAST_DAYS = 1 # Number of days of forecast, limited to 3 days with the free tier API subscription

  attr_reader :query, :forecast

  def self.get_forecast(query)
    new(query).get_forecast
  end

  def initialize(query)
    @weather_api_key = ENV['WEATHER_API_KEY'].presence || Rails.application.credentials.weather_api_key.presence
    raise 'Missing Weather API Key' if @weather_api_key.blank?

    @forecast = Forecast.new(query: query)
    @query = query
  end

  def get_forecast
    response = JSON.parse(Net::HTTP.get(weather_api_uri, { key: @weather_api_key }))
    return forecast if response.blank? || response.has_key?('error')

    forecast.assign_attributes datetime: Time.parse(response.dig('current', 'last_updated')),
                               location_name: response.dig('location', 'name'),
                               location_region: response.dig('location', 'region'),
                               current_temp_f: response.dig('current', 'temp_f'),
                               condition: response.dig('current', 'condition', 'text'),
                               icon: "https:#{response.dig('current', 'condition', 'icon')}",
                               current_temp_c: response.dig('current', 'temp_c'),
                               min_temp_f: response.dig('forecast', 'forecastday')[0]['day']['mintemp_f'],
                               min_temp_c: response.dig('forecast', 'forecastday')[0]['day']['mintemp_c'],
                               max_temp_f: response.dig('forecast', 'forecastday')[0]['day']['maxtemp_f'],
                               max_temp_c: response.dig('forecast', 'forecastday')[0]['day']['maxtemp_c']

    forecast
  end

  private

    def weather_api_uri
      URI.parse("https://api.weatherapi.com/v1/forecast.json?q=#{query}&days=#{FORECAST_DAYS}")
    end
end
