module ApplicationHelper
  def formatted_date(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%-m/%-d/%Y")
  end

  def formatted_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%-l:%M %p")
  end

  def icon(icon_name, text=nil, options={})
    options, text = text, nil if text.is_a?(Hash)
    options.merge!(class: "fas fa-#{icon_name} #{options[:class]}")

    content = content_tag(:i, nil, options)
    content = content + content_tag(:span, text, style: "margin-left: 0.25rem;") if text.present?
    content
  end
end
