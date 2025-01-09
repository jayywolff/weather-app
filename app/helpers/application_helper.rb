module ApplicationHelper
  # Formats a DateTime object as a user friendly string for display
  # Optionally can prefix the weekday
  def format_datetime(datetime, weekday: false)
    return '' if datetime.blank?

    datetime.strftime("#{'%A ' if weekday}%B #{datetime.day.ordinalize}, %Y %-l:%M %p")
  end
end
