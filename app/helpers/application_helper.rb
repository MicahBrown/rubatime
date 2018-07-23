module ApplicationHelper
  def formatted_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%b %e, %Y %-l:%M %p")
  end
end
