class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage

  validates :name, :cage, presence: true

  validate :cage_is_active, if: -> { will_save_change_to_cage_id? && cage_id.present? }
  validate :cage_has_only_my_diet, if: -> { will_save_change_to_cage_id? && cage_id.present? }

  private

  def cage_is_active
    if cage.down?
      errors.add(:base, 'Cannot move a dinosaur into a powered down cage!')
    end
  end

  def cage_has_only_my_diet
    diets_that_arent_mine = DIETARY_TYPES.values - Array(species.dietary_type) # currently there will only be 1 other type, but in future could be more.
    diets_in_cage = cage.dinosaurs.joins(:species).pluck('species.dietary_type')

    cage_has_another_diet = (diets_in_cage & diets_that_arent_mine).size.positive?

    if cage_has_another_diet
      errors.add(:base, 'Cannot move a dinosaur into a cage with dinosaurs of a different diet type!')
    end
  end


end