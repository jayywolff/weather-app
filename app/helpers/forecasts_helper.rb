module ForecastsHelper

  # Get the bootstrap temperature icon associated with the provided temperature
  # Accepts a float/int temperature in Fahrenheit and returns an icon based on the temperature
  # biased opinions on temperature ratings
  def temperature_icon(temperature)
    return 'thermometer' if temperature.blank?

    case
    when temperature < 20
      'thermometer-snow'
    when temperature < 40
      'thermometer-low'
    when temperature <= 73
      'thermometer-half'
    when temperature < 90
      'thermometer-high'
    when temperature > 90
      'thermometer-sun'
    else
      'thermometer'
    end
  end
end
