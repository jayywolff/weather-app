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
    return forecast if forecast.invalid?

    response = fetch_forecast
    if response.blank?
      forecast.errors.add :query, 'failed to get weather. Please try again'
      return forecast
    elsif response.has_key?('error')
      forecast.errors.add :query, "failed: #{response.dig('error', 'message')}"
      return forecast
    end

    forecast.assign_attributes datetime: Time.find_zone(Rails.configuration.time_zone).parse(response.dig('current', 'last_updated')),
                               location_name: response.dig('location', 'name'),
                               location_region: response.dig('location', 'region'),
                               condition: response.dig('current', 'condition', 'text'),
                               icon: "https:#{response.dig('current', 'condition', 'icon')}",
                               current_temp_f: response.dig('current', 'temp_f'),
                               current_temp_c: response.dig('current', 'temp_c'),
                               min_temp_f: response.dig('forecast', 'forecastday')[0]['day']['mintemp_f'],
                               min_temp_c: response.dig('forecast', 'forecastday')[0]['day']['mintemp_c'],
                               max_temp_f: response.dig('forecast', 'forecastday')[0]['day']['maxtemp_f'],
                               max_temp_c: response.dig('forecast', 'forecastday')[0]['day']['maxtemp_c']

    forecast
  end

  private

    def fetch_forecast
      begin
        response = Rails.cache.read(forecast_cache_key)
        if response.present?
          forecast.cached_query = true
          return JSON.parse(response)
        end

        response = weather_api_forecast
        Rails.cache.write(forecast_cache_key, response, expires_in: 30.minutes)

        JSON.parse(response)
      rescue StandardError => e
        forecast.errors.add :query, 'failed to get weather. Please try again'
      end
    end

    def forecast_cache_key
      "forecast/#{query.parameterize}"
    end

    def weather_api_forecast
      Net::HTTP.get(weather_api_uri, key: @weather_api_key)
    end

    def weather_api_uri
      URI.parse("https://api.weatherapi.com/v1/forecast.json?q=#{query}&days=#{FORECAST_DAYS}")
    end
end
