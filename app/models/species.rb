class Species < ApplicationRecord
  has_many :dinosaurs

  validates :dietary_type, presence: true

  enum dietary_type: {
    herbivore: 0,
    carnivore: 1
  }

  # used to include the amount of a given species currently in the park when returning data from the API.
  scope :with_amount_in_park, -> { select('species.*, COUNT(dinosaurs.id) AS amount_in_park').left_joins(:dinosaurs).group('species.id') }
end
