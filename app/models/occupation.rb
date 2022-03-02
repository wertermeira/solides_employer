class Occupation < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
end
