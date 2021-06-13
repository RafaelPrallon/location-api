class Rating < ApplicationRecord
  belongs_to :location
  belongs_to :user

  validates :grade, :comment, presence: true

  validates :grade, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :comment, length: { maximum: 140 }
end
