class Occupation < ApplicationRecord
  belongs_to :company

  scope :published, -> { where(active: true) }

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
end
