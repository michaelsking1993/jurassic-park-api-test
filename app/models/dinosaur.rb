class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage

  validates :name, :cage, presence: true

  validate :cage_is_active, :cage_has_only_my_diet,
           :cage_has_carnivores_of_only_same_species, :cage_has_room,
           if: -> { will_save_change_to_cage_id? && cage_id.present? }

  private

  # cannot add dinosaurs to an inactive cage
  def cage_is_active
    unless cage.active?
      errors.add(:base, 'Cannot move a dinosaur into a powered down cage!')
    end
  end

  # cannot add dinosaurs to a cage that is already at max capacity
  def cage_has_room
    unless cage.dinosaurs.size < cage.max_capacity # TODO: check if cage is being queried for twice here. If so, optimize.
      errors.add(:base, 'Cannot move a dinosaur into a cage that is already at max capacity!')
    end
  end


  # cannot add dinosaurs to a cage with dinosaurs of a different dietary type
  def cage_has_only_my_diet
    diets_in_cage = cage.dinosaurs.joins(:species).pluck('species.dietary_type')
    diets_in_cage_other_than_mine = diets_in_cage - [species.dietary_type]

    if diets_in_cage_other_than_mine.any?
      errors.add(:base, 'Cannot move a dinosaur into a cage with dinosaurs of a different diet type!')
    end
  end

  # cannot add carnivores to a cage with carnivores of a different species
  def cage_has_carnivores_of_only_same_species
    my_dietary_type = species.dietary_type
    if my_dietary_type == DIETARY_TYPES[:carnivore]
      species_in_cage = cage.dinosaurs.joins(:species).pluck('species.id')
      other_species_in_cage = species_in_cage - [species.id]

      if other_species_in_cage.any?
        errors.add(:base, 'Cannot move a carnivore into a cage with a carnivore of a different species!')
      end
    end
  end
end