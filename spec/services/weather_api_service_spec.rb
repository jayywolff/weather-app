require 'rails_helper'

RSpec.describe WeatherApiService, type: :service do
  subject(:service) { described_class.new(query) }

  let(:query) { 'Tampa, Florida' }

  context 'when the app is missing the Weather API Key' do
    before do
      allow(ENV).to receive(:[]).with('WEATHER_API_KEY').and_return nil
      allow(Rails.application.credentials).to receive(:weather_api_key).and_return nil
    end

    it 'raises an error' do
      expect { service }.to raise_error 'Missing Weather API Key'
    end
  end

  describe '.get_forecast(query)' do
    let(:weather_api_uri) { URI.parse("https://api.weatherapi.com/v1/forecast.json?q=#{query}&days=1") }
    let(:weather_api_key) { Rails.application.credentials.weather_api_key }

    before do
      # Mock the WeatherAPI call and return a fixture json response
      # NOTE: typically might use a gem like webmock for this in a real app to prevent any http requests in tests
      allow(Net::HTTP).to receive(:get).with(weather_api_uri, key: weather_api_key).and_return response
    end

    context 'when the forecast query is valid' do
      let(:response) { fixture_file_upload('forecast_success_response.json').read }

      it 'returns a forecast with current forecast data from the WeatherAPI' do
        forecast = described_class.get_forecast(query)

        expect(forecast).to be_a Forecast
        expect(forecast.datetime).to eq DateTime.parse('2025-01-09 19:30:00 -0500').in_time_zone('Eastern Time (US & Canada)')
        expect(forecast.location_name).to eq 'Tampa'
        expect(forecast.location_region).to eq 'Florida'
        expect(forecast.condition).to eq 'Clear'
        expect(forecast.icon).to eq 'https://cdn.weatherapi.com/weather/64x64/night/113.png'
        expect(forecast.current_temp_f).to eq 51.1
        expect(forecast.current_temp_c).to eq 10.6
        expect(forecast.min_temp_f).to eq 40.8
        expect(forecast.min_temp_c).to eq 4.9
        expect(forecast.max_temp_f).to eq 61.9
        expect(forecast.max_temp_c).to eq 16.6
      end
    end

    context 'when the forecast query is invalid' do
      let(:response) { fixture_file_upload('forecast_error_response.json').read }
      let(:query) { '' }

      it 'returns a forecast with errors' do
        forecast = described_class.get_forecast(query)

        expect(forecast).to be_invalid
        expect(forecast.errors.full_messages.to_sentence).to eq "Query can't be blank"
      end
    end

    context 'when a bad query returns an error from the WeatherAPI ' do
      let(:response) { fixture_file_upload('forecast_error_response.json').read }

      let(:query) { 'some fake city' }

      it 'returns a forecast with errors' do
        forecast = described_class.get_forecast(query)
        expect(forecast.errors.any?).to be true
        expect(forecast.errors.full_messages.to_sentence).to eq 'Query failed: No matching location found.'
      end
    end
  end
end
