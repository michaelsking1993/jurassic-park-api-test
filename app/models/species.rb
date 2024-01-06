class Species < ApplicationRecord
  has_many :dinosaurs

  validates :dietary_type, presence: true

  enum dietary_type: {
    herbivore: 0,
    carnivore: 1
  }
end