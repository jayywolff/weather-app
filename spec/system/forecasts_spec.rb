require 'rails_helper'

RSpec.describe 'Forecasts', type: :system do
  describe 'index' do
    let(:weather_api_uri) { URI.parse("https://api.weatherapi.com/v1/forecast.json?q=#{query}&days=1") }
    let(:weather_api_key) { Rails.application.credentials.weather_api_key }

    before do
      # Mock the WeatherAPI call and return a fixture json response
      allow(Net::HTTP).to receive(:get).with(weather_api_uri, key: weather_api_key).and_return response
    end

    context 'when user searches for a forecast in a legit city' do
      let(:response) { fixture_file_upload('forecast_success_response.json').read }
      let(:query) { 'Tampa FL' }

      it 'prompts user for address and displays forecast' do
        visit '/forecasts'
        expect(page).to have_content 'Check the current forecast in your area!'
        fill_in 'Search by Address, City, or Zip Code:', with: query
        click_button 'Search'

        expect(page).to have_content 'Forecast outlook as of Thursday January 9th, 2025 7:30 PM'
        expect(page).to have_css '.forecast-location', text: 'Tampa, Florida'
        expect(page).to have_css '.forecast-current-temp', text: '51°(F) | 10°(C)'
        expect(page).to have_css '.forecast-min-temp', text: '40°(F) | 4°(C)'
        expect(page).to have_css '.forecast-max-temp', text: '61°(F) | 16°(C)'
        expect(page).to have_css '.forecast-condition', text: 'Clear'
      end
    end

    context 'when user searches for a forecast in a city that cannot be found by the WeatherAPI' do
      let(:query) { 'some fake city' }
      let(:response) { fixture_file_upload('forecast_error_response.json').read }

      it 'prompts user for address and displays an error alert message' do
        visit '/forecasts'
        expect(page).to have_content 'Check the current forecast in your area!'
        fill_in 'Search by Address, City, or Zip Code:', with: query
        click_button 'Search'

        expect(page).to have_css '.alert.alert-danger', text: 'Query failed: No matching location found.'

        expect(page).not_to have_content 'Forecast outlook'
        expect(page).not_to have_css '.forecast-location'
        expect(page).not_to have_css '.forecast-current-temp'
        expect(page).not_to have_css '.forecast-min-temp'
        expect(page).not_to have_css '.forecast-max-temp'
        expect(page).not_to have_css '.forecast-condition'
      end
    end

    context 'when user submits the form without filling in a search string' do
      let(:query) { ' ' }
      let(:response) { fixture_file_upload('forecast_error_response.json').read }

      it 'prompts user for address and displays an error alert message' do
        visit '/forecasts'
        expect(page).to have_content 'Check the current forecast in your area!'
        fill_in 'Search by Address, City, or Zip Code:', with: query
        click_button 'Search'

        expect(page).to have_css '.alert.alert-danger', text: "Query can't be blank"

        expect(page).not_to have_content 'Forecast outlook'
        expect(page).not_to have_css '.forecast-location'
        expect(page).not_to have_css '.forecast-current-temp'
        expect(page).not_to have_css '.forecast-min-temp'
        expect(page).not_to have_css '.forecast-max-temp'
        expect(page).not_to have_css '.forecast-condition'
      end
    end
  end
end
