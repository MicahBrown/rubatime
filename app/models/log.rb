class Log < ApplicationRecord
  belongs_to :project, optional: true

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
    if value.is_a?(String) && value.match(/[a-z]{3}\s\d?\d,\s\d{4}/i)
      value = ActiveSupport::TimeZone["Mountain Time (US & Canada)"].parse(value)
    end

    super(value)
  end

  def end_at=(value)
    if value.is_a?(String) && value.match(/[a-z]{3}\s\d?\d,\s\d{4}/i)
      value = ActiveSupport::TimeZone["Mountain Time (US & Canada)"].parse(value)
    end

    super(value)
  end

  private

    def valid_time_range?
      start_at? && end_at? && start_at <= end_at
    end
end
