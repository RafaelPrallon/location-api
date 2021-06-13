class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :registerable,
         :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  validates :email, :username, uniqueness: true
  validates :email, :username, presence: true

  has_many :ratings, dependent: :destroy
end
