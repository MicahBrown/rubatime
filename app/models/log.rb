class Log < ApplicationRecord
  PAY_PERIOD_START_DATE = Date.new(2018, 7, 15).freeze
  PAY_PERIOD_DURATION = 2.weeks.freeze

  belongs_to :project, optional: true

  scope :active, -> { where(active: true) }
  scope :in_datetime_range, -> (sdatetime, edatetime) { where("(logs.start_at <= ?) AND (logs.end_at >= ?)", edatetime, sdatetime) }

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

  def set_elapsed_time
    if valid_time_range?
      self.elapsed_seconds = end_at - start_at
    end
  end

  def hours(scale=2)
    return unless valid_time_range?
    (elapsed_seconds / 60.0 / 60).round(scale)
  end

  def start_at=(value)
    if value.is_a?(Hash)
      value = value[:date].blank? && value[:time].blank? ? "" : "#{value[:date]} #{value[:time]}"
    end

    if value.is_a?(String) && value.match(/(\d?\d)\/(\d?\d)\/(\d{4})(.+)/i)
      value = "#{$2}/#{$1}/#{$3}#{$4}"
      value = ActiveSupport::TimeZone[TIMEZONE].parse(value)
    end

    super(value)
  end

  def end_at=(value)
    if value.is_a?(Hash)
      value = value[:date].blank? && value[:time].blank? ? "" : "#{value[:date]} #{value[:time]}"
    end

    if value.is_a?(String) && value.match(/\d?\d\/\d?\d\/\d{4}(.+)/i)
      value = "#{$2}/#{$1}/#{$3}#{$4}"
      value = ActiveSupport::TimeZone[TIMEZONE].parse(value)
    end

    super(value)
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
    prev_sdate = current_period.min - PAY_PERIOD_DURATION
    prev_edate = current_period.min - 1.day

    prev_sdate..prev_edate
  end

  def self.current_pay_period_dates
    today = Date.today
    sdate = PAY_PERIOD_START_DATE.dup
    edate = nil

    loop do
      next_sdate = sdate + PAY_PERIOD_DURATION
      edate = next_sdate - 1.day
      break if edate >= today

      sdate = next_sdate
    end

    sdate..edate
  end


  def self.current_pay_period_elapsed_seconds
    date_range = current_pay_period_dates
    elapsed_seconds_for(date_range.min, date_range.max)
  end

  private

    def valid_time_range?
      start_at? && end_at? && start_at <= end_at
    end
end
