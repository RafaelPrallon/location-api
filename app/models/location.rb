# Model to store locations
class Location < ApplicationRecord
  validates :name, :street, :number, :city, :state, :zip_code, presence: true
  validates :name, uniqueness: true
  validates :street, length: {
    in: 5..50,
    too_short: I18n.t('errors.locations.street.too_short'),
    too_long: I18n.t('errors.locations.street.too_long')
  }
  validates :zip_code, format: { with: /\A\d{8}\z/, message: I18n.t('errors.locations.zip_code.only_numbers') }
  validates :zip_code, length: { is: 8, message: I18n.t('errors.locations.zip_code.length') }
  validates :state, format: { with: /\A[A-Z]{2}\z/, message: I18n.t('errors.locations.state') }

  has_many :ratings, dependent: :destroy
end
