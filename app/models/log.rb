class Log < ApplicationRecord
  belongs_to :project, optional: true

  validates :start_at, presence: true
  validates :end_at, presence: {if: :active?}
  validates :project, presence: {if: :active?}
  validates :description, presence: {if: :active?}

  before_validation :set_elapsed_time

  def set_elapsed_time
    if start_at? && end_at? && start_at <= end_at
      self.elapsed_seconds = end_at - start_at
    end
  end
end
