class PayRate < ApplicationRecord
  scope :latest, -> { order("effective_start_date DESC") }

  validates :effective_start_date, presence: true
  validates :effective_end_date, presence: {unless: :current?}
  validate :end_at_works_with_start_at
  validate :conflict_with_other_rate, on: :create

  def end_at_works_with_start_at
    if effective_start_date? && effective_end_date? && effective_end_date < effective_start_date
      errors.add(:effective_end_date, "must not be greater than the start at")
    end
  end

  def conflict_with_other_rate
    if effective_start_date?
      max = self.class.maximum(:effective_start_date)
      errors.add(:effective_start_date, "conflicts with another pay rate (must be greater than #{max})") if max && max >= self.effective_start_date
    end
  end

  after_save :update_current_status

  def update_current_status
    if current? && (saved_change_to_id? || saved_change_to_current?)
      pr = self.class.latest.where(current: true).where(effective_end_date: nil).where.not(id: self.id).first
      pr.update_attributes!(effective_end_date: self.effective_start_date - 1.day, current: false) if pr
    end
  end

  def effective_start_date=(value)
    super convert_date_value(value)
  end

  def self.current
    latest.where(current: true).first
  end
end
