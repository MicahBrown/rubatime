class Invoice < ApplicationRecord
  enum status: [:pending, :enqueued, :completed, :errored]

  has_one_attached :pdf

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :single_pay_rate, on: :create
  validate :end_date_works_with_start_date

  def single_pay_rate
    if start_date? && end_date?
      rates = pay_rates

      if rates.size > 1
        errors.add(:base, "multiple pay rates found for this date range (#{rates.map { |r| [r.start_date, r.end_date].join(" - ") }.to_sentence})")
      elsif rates.size == 0
        errors.add(:base, "no pay rates found for this date range")
      end
    end
  end

  def end_date_works_with_start_date
    if start_date? && end_date? && end_date < start_date
      errors.add(:end_date, "must not be greater than the start date")
    end
  end

  def enqueue!
    InvoiceJob.perform_later(self)
  end

  def process!
    InvoiceGenerator.create!(self)
  end

  def start_date=(value)
    super convert_date_value(value)
  end

  def end_date=(value)
    super convert_date_value(value)
  end

  def pay_rates
    PayRate.where("effective_start_date <= ?", start_date).where("effective_end_date IS NULL OR effective_end_date >= ?", end_date)
  end
end
