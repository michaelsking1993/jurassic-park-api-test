class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage

  validates :name, :cage_id, :species_id, presence: true

  validate :cage_is_active, :cage_has_only_my_diet,
           :cage_has_carnivores_of_only_same_species, :cage_has_room,
           if: -> { will_save_change_to_cage_id? && cage_id.present? } # if changing cages

  # used to include the name of each dinosaur's species in the data returned from the API.
  scope :with_species_name, -> { joins(:species).select('dinosaurs.*, species.title AS species_name') }

  private

  # cannot add dinosaurs to an inactive cage
  def cage_is_active
    unless cage.active?
      errors.add(:base, 'Cannot move a dinosaur into a powered down cage!')
    end
  end

  # TODO: check for excess queries to the cage object here. If so, optimize.

  # cannot add dinosaurs to a cage that is already at max capacity
  def cage_has_room
    unless cage.dinosaurs.size < cage.max_capacity
      errors.add(:base, 'Cannot move a dinosaur into a cage that is already at max capacity!')
    end
  end

  # cannot add dinosaurs to a cage with dinosaurs of a different dietary type (ex. no herbivores in the same cage with carnivores)
  def cage_has_only_my_diet
    diets_in_cage = cage.dinosaurs.joins(:species).pluck('species.dietary_type')
    my_diet = species.dietary_type

    unless diets_in_cage.all? { |diet| diet == my_diet }
      errors.add(:base, 'Cannot move a dinosaur into a cage with dinosaurs of a different diet type!')
    end
  end

  # cannot add carnivores to a cage with carnivores of a different species
  def cage_has_carnivores_of_only_same_species
    if (my_species = species).dietary_type == DIETARY_TYPES[:carnivore]
      species_ids_in_cage = cage.dinosaurs.joins(:species).pluck('species.id')

      unless species_ids_in_cage.all? { |species_id| species_id == my_species.id }
        errors.add(:base, 'Cannot move a carnivore into a cage with a carnivore of a different species!')
      end
    end
  end
end
