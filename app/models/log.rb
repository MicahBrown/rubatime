class Log < ApplicationRecord
  belongs_to :project, optional: true

  validates :start_at, presence: true
  validates :end_at, presence: {if: :active?}
  validates :project, presence: {if: :active?}
  validates :description, presence: {if: :active?}
end
