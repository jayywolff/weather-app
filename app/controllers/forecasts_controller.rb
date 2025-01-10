class ForecastsController < ApplicationController
  def index
    @forecast = WeatherApiService.get_forecast(params[:address])
    flash.now[:alert] = @forecast.errors.full_messages if @forecast.errors.any?
  end
end
