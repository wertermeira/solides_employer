class Company < ApplicationRecord
  validates :name, :cnpj, :email, presence: true
  validates :cnpj, :email, uniqueness: true
  validates :name, length: { maximum: 100 }
  validates :email, email: true, allow_blank: true
  validates :cnpj, cnpj: true, allow_blank: true
end
