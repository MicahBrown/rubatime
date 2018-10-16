class Expense < ApplicationRecord
  enum category: [:lodging]

  scope :in_date_range, -> (sdate, edate) { where("expense_date BETWEEN ? AND ?", sdate, edate) }

  validates :expense_date, presence: true
  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :category, presence: true

  def formatted_category
    self.class.format_category(category)
  end

  def self.format_category(category)
    case category
    when "lodging" then "Lodging"
    else
      raise UnknownCategory
    end
  end

  class UnknownCategory < StandardError; end
end
