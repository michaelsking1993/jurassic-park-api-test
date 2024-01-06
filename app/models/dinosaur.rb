class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage

  validates :name, presence: true
end