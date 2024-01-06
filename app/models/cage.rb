class Cage < ApplicationRecord
  has_many :dinosaurs

  validates :power_status, presence: true

  # make sure the cage is empty before powering down
  validate :cage_is_empty_if_powering_down

  enum power_status: {
    DOWN: 0,
    ACTIVE: 1
  }

  private

  def cage_is_empty_if_powering_down
    is_powering_down = power_status_change.present? && power_status_change[1] == POWER_STATUSES[:down]

    if is_powering_down
      if dinosaurs.any?
        errors.add(:base, 'Cannot power down a cage when dinosaurs are inside!')
      end
    end
  end
end
