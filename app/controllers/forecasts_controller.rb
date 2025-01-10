class ForecastsController < ApplicationController
  def index
    if params.has_key?(:address)
      @forecast = WeatherApiService.get_forecast(params[:address])
      flash.now[:alert] = @forecast.errors.full_messages if @forecast.errors.any?
    else
      @forecast = Forecast.new
    end
  end
end
