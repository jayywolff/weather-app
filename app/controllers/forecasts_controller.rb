class ForecastsController < ApplicationController
  def index
    @forecast = WeatherApiService.get_forecast(params[:address])
  end
end
