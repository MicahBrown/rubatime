class Project < ApplicationRecord
  validates :name, presence: true

  scope :alphabetized, -> { order("projects.name ASC") }
end
