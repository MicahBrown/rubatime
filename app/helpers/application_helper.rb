module ApplicationHelper
  def formatted_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone("Mountain Time (US & Canada)").strftime("%b %e, %Y %-l:%M %p")
  end
end
