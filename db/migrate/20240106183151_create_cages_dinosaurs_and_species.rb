class CreateCagesDinosaursAndSpecies < ActiveRecord::Migration[7.1]
  def change
    # This table tracks the cages in which the dinosaurs will be held.
    create_table :cages do |t|
      t.timestamps

      t.integer :max_capacity, null: false, default: 1 # how many dinosaurs can this cage hold?
      t.integer :power_status, null: false, default: 1 # will be an enum with 2 initial statuses ('active', and 'down'), default will be 'active'.
    end

    # This table tracks the different species of the dinosaurs in the park.
    create_table :species do |t|
      t.timestamps

      t.string :title, null: false # the name of the species. Called title instead of 'name' so as not to be confused with the specific name of each dinosaur.
      t.integer :dietary_type, null: false # will be an enum with 2 initial types ("herbivore" and "carnivore"), maybe with other types in the future (ex. omnivore).
    end

    # This table tracks the specific dinosaurs that the park will contain.
    create_table :dinosaurs do |t|
      t.timestamps

      t.string :name, null: false # the specific name of the dinosaur, ex. "John", "Mary", "Jane".

      t.references :species, null: false, foreign_key: true# each dinosaur must have a species that it is a part of.
      t.references :cage, null: false, foreign_key: true # each dinosaur must have a cage where it sleeps/eats/chills.
    end
  end
end
