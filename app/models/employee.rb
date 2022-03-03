class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :occupation

  validates :name, :cpf, :email, :phone_number, :start_date, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, :cpf, uniqueness: true
  validates :email, email: true, allow_blank: true
  validates :phone_number, phone: true, allow_blank: true
  validates :cpf, cpf: true, allow_blank: true

  validate :validate_start_date, on: :create, if: -> { errors.blank? }
  validate :validate_end_date, if: -> { errors.blank? && end_date.present? }
  validate :validate_occupation, if: -> { errors.blank? && occupation.present? }

  private

  def validate_start_date
    errors.add(:start_date, I18n.t('errors.messages.invalid_start_date')) if start_date > Date.today
  end

  def validate_end_date
    errors.add(:end_date, I18n.t('errors.messages.invalid_end_date')) if end_date < start_date
  end

  def validate_occupation
    errors.add(:occupation, I18n.t('errors.messages.invalid_occupation')) if occupation.company != company
  end
end
