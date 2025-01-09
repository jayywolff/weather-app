require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'GET /index' do
    it 'prompts for address' do
      get '/forecasts'
      expect(response.body).to include 'Search by City or Zip Code'
    end
  end
end
