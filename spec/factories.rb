FactoryBot.define do
  factory :cage do
    max_capacity { rand(1..10) }

    trait :active do
      power_status { POWER_STATUSES[:active] }
    end

    trait :down do
      power_status { POWER_STATUSES[:down] }
    end
  end

  factory :dinosaur do
    name { Faker::Name.first_name }
    association :cage
    association :species

    trait :herbivore do
      species { create(:species, :herbivore) }
    end

    trait :carnivore do
      species { create(:species, :carnivore) }
    end
  end

  factory :species do
    title { Faker::Creature::Animal.name } # this is as close as we can get to faking dinosaur names, unless we find another library or make our own
    dietary_type { DIETARY_TYPES.values.sample }

    trait :herbivore do
      dietary_type { DIETARY_TYPES[:herbivore]}
    end

    trait :carnivore do
      dietary_type { DIETARY_TYPES[:carnivore]}
    end
  end
end