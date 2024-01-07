# This should be an idempotent file that provides seed data for a local environment.

if Species.count >= 20 && Dinosaur.count >= 200
  puts 'No need to run this script, there is plenty of data!'
  return
end

  # Create the dinosaur species, 10 carnivore species and 10 herbivore species.
carnivore_dinosaur_species = %w[Tyrannosaurus Velociraptor Spinosaurus Megalosaurus Allosaurus Carnotaurus Giganotosaurus Dilophosaurus Baryonyx Utahraptor]
herbivore_dinosaur_species = %w[Brachiosaurus Stegosaurus Ankylosaurus Triceratops Apatosaurus Parasaurolophus Iguanodon Corythosaurus Edmontosaurus Protoceratops]

carnivore_dinosaur_species.map! do |carnivore_species|
  Species.create!(title: carnivore_species, dietary_type: DIETARY_TYPES[:carnivore])
end

herbivore_dinosaur_species.map! do |herbivore_species|
  Species.create!(title: herbivore_species, dietary_type: DIETARY_TYPES[:herbivore])
end

all_dinosaur_species = [carnivore_dinosaur_species, herbivore_dinosaur_species].flatten

# create dinosaurs, 10 of each species.
all_dinosaur_species.each do |dinosaur_species|
  cage = Cage.create!(max_capacity: rand(10..15))
  10.times do
    Dinosaur.create!(name: Faker::Name.first_name, cage: cage, species: dinosaur_species)
  end
end
