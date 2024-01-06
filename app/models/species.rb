class Species < ApplicationRecord
  enum dietary_type: {
    HERBIVORE: 0,
    CARNIVORE: 1
  }
end