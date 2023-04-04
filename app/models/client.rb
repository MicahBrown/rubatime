class Client < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :alphabetized, -> { order("clients.name ASC") }
  scope :unarchived, -> { where(archived_at: nil) }

  def archived=(status)
    status = status == 'true' if status.is_a?(String)

    if status
      self.archived_at ||= Time.now
    else
      self.archived_at = nil
    end
  end

  def archived?
    archived_at?
  end
end
