class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def convert_date_value(value)
    if value.is_a?(Hash)
      value =
        if value[:date].blank? && value[:time].blank?
          ""
        elsif value[:date].match(/\d{4}/)
          "#{value[:date]} #{value[:time]}".in_time_zone(TIMEZONE)
        elsif value[:date].match(/\d?\d\/\d?\d\/\d{4}/)
          "#{value[:date]} #{value[:time]}"
        else
          raise ArgumentError, "invalid hash value"
        end
    end

    if value.is_a?(String) && value.match(/(\d?\d)\/(\d?\d)\/(\d{4})(.+)/i)
      value = "#{$2}/#{$1}/#{$3}#{$4}"
      value = ActiveSupport::TimeZone[TIMEZONE].parse(value)
    end

    value
  end
end
