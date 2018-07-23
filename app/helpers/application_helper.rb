module ApplicationHelper
  def formatted_time(datetime)
    return unless datetime.present?
    datetime.strftime("%b %e, %Y %l:%M %p")
  end
end
