class Cage < ApplicationRecord
  has_many :dinosaurs

  validates :power_status, presence: true
  validates :max_capacity, numericality: { only_integer: true, message: 'must be an integer' }

  # make sure the cage is empty before powering down
  validate :cage_is_empty_if_powering_down

  enum power_status: {
    down: 0,
    active: 1
  }

  scope :with_dinosaurs_contained, -> { select('cages.*, COUNT(dinosaurs.id) AS dinosaurs_contained').left_joins(:dinosaurs).group('cages.id') }

  private

  def cage_is_empty_if_powering_down
    is_powering_down = will_save_change_to_power_status? && down?

    if is_powering_down && dinosaurs.any?
      errors.add(:base, 'Cannot power down a cage when dinosaurs are inside!')
    end
  end
end
