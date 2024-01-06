class Cage < ApplicationRecord
  has_many :dinosaurs

  validates :power_status, presence: true

  enum power_status: {
    DOWN: 0,
    ACTIVE: 1
  }
end
