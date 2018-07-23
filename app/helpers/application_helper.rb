module ApplicationHelper
  def formatted_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%b %e, %Y %-l:%M %p")
  end

  def icon(icon_name, text=nil, options={})
    options, text = text, nil if text.is_a?(Hash)
    options.merge!(class: "fas fa-#{icon_name} #{options[:class]}")

    content = content_tag(:i, nil, options)
    content = content + " " + text if text.present?
    content
  end
end
