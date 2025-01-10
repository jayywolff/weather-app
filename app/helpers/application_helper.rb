module ApplicationHelper
  # Formats a DateTime object as a user friendly string for display
  # Optionally can prefix the weekday
  def format_datetime(datetime, weekday: false)
    return '' if datetime.blank?

    datetime.strftime("#{'%A ' if weekday}%B #{datetime.day.ordinalize}, %Y %-l:%M %p")
  end

  # returns the bootstrap alert class for a given alert type
  def flash_bootstrap_alert_type(type)
    case type
    when 'alert', 'danger', 'error'
      'alert-danger'
    when 'notice', 'success'
      'alert-success'
    else
      'alert-info'
    end
  end

  # returns a bootstrap icon for a given alert type
  def flash_bootstrap_icon(type)
    case type
    when 'alert', 'danger', 'error'
      'exclamation-triangle-fill'
    when 'notice', 'success'
      'check-circle'
    else
      'exclamation-circle'
    end
  end
end
