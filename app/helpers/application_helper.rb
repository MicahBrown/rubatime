module ApplicationHelper
  def formatted_date(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%-m/%-d/%Y")
  end

  def formatted_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%-l:%M %p")
  end

  def input_date(datetime)
    return unless datetime.present?
    datetime = datetime.in_time_zone(TIMEZONE)
    datetime.to_date.to_s
  end

  def input_time(datetime)
    return unless datetime.present?
    datetime.in_time_zone(TIMEZONE).strftime("%H:%M")
  end

  def icon(icon_name, text=nil, options={})
    options, text = text, nil if text.is_a?(Hash)
    options.merge!(class: "fas fa-#{icon_name} #{options[:class]}")

    content = content_tag(:i, nil, options)
    content = content + content_tag(:span, text, style: "margin-left: 0.25rem;") if text.present?
    content
  end

  def form_errors(object)
    return unless object.present?
    errors = object.errors.full_messages
    return unless errors.present?

    render "shared/form_errors", errors: errors
  end

  def estimated_tax
    number_to_currency(EstimatedTax.last&.value || 0)
  end
end
