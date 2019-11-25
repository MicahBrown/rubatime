require 'date_parser'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def convert_date_value(value)
    DateParser.parse(value)
  end
end
