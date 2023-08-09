class Log < ApplicationRecord
  belongs_to :project, optional: true

  scope :active, -> { where(active: true) }
  scope :in_datetime_range, -> (sdatetime, edatetime) { where("(logs.start_at <= ?) AND (logs.end_at >= ?)", edatetime, sdatetime) }
  scope :ordered, -> { order("logs.start_at DESC, logs.end_at DESC") }

  validates :start_at, presence: true
  validates :end_at, presence: {if: :active?}
  validates :project, presence: {if: :active?}
  validates :description, presence: {if: :active?}
  validate :end_at_works_with_start_at

  def end_at_works_with_start_at
    if start_at? && end_at? && end_at < start_at
      errors.add(:end_at, "must not be greater than the start at")
    end
  end

  before_validation :set_elapsed_time
  after_save :update_estimated_taxes

  def set_elapsed_time
    if valid_time_range?
      self.elapsed_seconds = end_at - start_at
    end
  end

  def update_estimated_taxes
    EstimatedTaskCalculatorJob.perform_later if saved_change_to_start_at? || saved_change_to_end_at? || saved_change_to_active?
  end

  def hours(scale=2)
    return unless valid_time_range?
    (elapsed_seconds / 60.0 / 60).round(scale)
  end

  def start_at=(value)
    super convert_date_value(value)
  end

  def end_at=(value)
    super convert_date_value(value)
  end

  def self.elapsed_seconds_for(start_at, end_at, only_include_active=true)
    start_at = start_at.in_time_zone(TIMEZONE) if start_at.is_a?(Date)
    end_at   = end_at.in_time_zone(TIMEZONE).end_of_day if end_at.is_a?(Date)

    logs = self.in_datetime_range(start_at, end_at)
    logs = logs.active if only_include_active

    seconds = logs.map do |log|
      s = log.start_at < start_at ? start_at : log.start_at
      e = log.end_at > end_at ? end_at : log.end_at
      e - s
    end

    seconds.inject(:+) || 0
  end

  def self.previous_pay_period_dates
    current_period = current_pay_period_dates
    prev_edate = current_period.min - 1.day
    sdate, edate =
      if prev_edate.day == 15
        [prev_edate.beginning_of_month, prev_edate]
      else
        [prev_edate.change(day: 16), prev_edate]
      end

    sdate..edate
  end

  def self.previous_pay_period_datetimes
    min, max = previous_pay_period_dates.min, previous_pay_period_dates.max
    min.in_time_zone(TIMEZONE).beginning_of_day..max.in_time_zone(TIMEZONE).end_of_day
  end

  def self.current_pay_period_dates
    today = Date.today
    sdate, edate =
      if today.day <= 15
        [today.beginning_of_month, today.change(day: 15)]
      else
        [today.change(day: 16), today.end_of_month]
      end

    sdate..edate
  end

  def self.current_pay_period_datetimes
    min, max = current_pay_period_dates.min, current_pay_period_dates.max
    min.in_time_zone(TIMEZONE).beginning_of_day..max.in_time_zone(TIMEZONE).end_of_day
  end


  def self.current_pay_period_elapsed_seconds
    date_range = current_pay_period_dates
    elapsed_seconds_for(date_range.min, date_range.max)
  end

  def self.parse_datetime_range(raw_start_date, raw_end_date)
    min, max = DateParser.parse(raw_start_date), DateParser.parse(raw_end_date)
    min.in_time_zone(TIMEZONE).beginning_of_day..max.in_time_zone(TIMEZONE).end_of_day
  end

  private

    def valid_time_range?
      start_at? && end_at? && start_at <= end_at
    end
end
