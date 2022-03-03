class Occupation < ApplicationRecord
  belongs_to :company
  has_many :employees, dependent: :nullify

  scope :published, -> { where(active: true) }

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
end
