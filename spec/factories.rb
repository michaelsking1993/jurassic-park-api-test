FactoryBot.define do
  factory :cage do
    max_capacity { rand(1..10) }
    power_status { Cage.power_statuses.keys.sample }
  end

  factory :dinosaur do
    name { Faker::Name.first_name }
    association :cage
    association :species
  end

  factory :species do
    title { Faker::Creature::Animal.name } # this is as close as we can get to faking dinosaur names, unless we find another library or make our own
    dietary_type { Species.dietary_types.keys.sample }
  end
end