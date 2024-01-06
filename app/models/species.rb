class Species < ApplicationRecord
  has_many :dinosaurs

  validates :dietary_type, presence: true

  enum dietary_type: {
    HERBIVORE: 0,
    CARNIVORE: 1
  }
end