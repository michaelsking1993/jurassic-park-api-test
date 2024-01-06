class Cage < ApplicationRecord
  enum power_status: {
    DOWN: 0,
    ACTIVE: 1
  }
end
