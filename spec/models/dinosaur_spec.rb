require 'rails_helper'

RSpec.describe Dinosaur do
  describe 'attributes' do
    it 'has the necessary columns' do
      expected_column_names = %w[name species_id cage_id]
      matching_column_names = Dinosaur.column_names & expected_column_names

      expect(matching_column_names.size).to eq(expected_column_names.size)
    end
  end


  describe 'validations' do
    context 'when creating a dinosaur' do
      it 'must have a name' do
        some_dinosaur = create(:dinosaur) # must use create to generated the associated species and cage objects
        expect(some_dinosaur).to be_valid

        some_dinosaur.name = nil
        expect(some_dinosaur).not_to be_valid
      end

      it 'must have a species' do
        some_dinosaur = create(:dinosaur) # must use create to generate an associated species object
        expect(some_dinosaur).to be_valid

        some_dinosaur.species_id = nil
        expect(some_dinosaur).not_to be_valid
      end

      it 'must have a cage' do
        some_dinosaur = create(:dinosaur) # must use create to generate an associated cage object
        expect(some_dinosaur).to be_valid

        some_dinosaur.cage_id = nil
        expect(some_dinosaur).not_to be_valid
      end
    end

    context 'when assigning dinosaurs to a cage' do
      describe 'power_status' do
        context 'if the cage is powered down' do
          it 'does not allow them to be moved into the cage' do
            inactive_cage = create(:cage, power_status: POWER_STATUSES[:down])
            some_dinosaur = create(:dinosaur)

            some_dinosaur.update(cage_id: inactive_cage.id)

            expect(some_dinosaur.errors.full_messages).to include('Cannot move a dinosaur into a powered down cage!')
            some_dinosaur.reload
            expect(some_dinosaur.cage_id).not_to eq(inactive_cage.id)
          end
        end

        context 'if the cage is active' do
          it 'allows them to be moved into the cage' do
            active_cage = create(:cage, power_status: POWER_STATUSES[:active])
            some_dinosaur = create(:dinosaur)

            some_dinosaur.update(cage_id: active_cage.id)

            some_dinosaur.reload
            expect(some_dinosaur.cage_id).to eq(active_cage.id)
          end
        end
      end

      describe 'dietary_type' do
        context 'when there is a dinosaur with a different dietary_type already in the cage (ex. a carnivore is in there with an herbivore trying to get in)' do
          it 'does not allow them in' do
            herbivore = create(:dinosaur, :herbivore)
            herbivore_cage = herbivore.cage

            carnivore = create(:dinosaur, :carnivore)

            carnivore.update(cage: herbivore_cage)
            expect(carnivore.errors.full_messages).to include('Cannot move a dinosaur into a cage with dinosaurs of a different diet type!')

            carnivore.reload
            expect(carnivore.cage_id).not_to eq(herbivore_cage.id)
          end
        end

        context 'when all the other dinosaurs have the same dietary_type as the one trying to get in' do
          it 'allows them in' do
            herbivore_1 = create(:dinosaur, :herbivore)
            herbivore_1_cage = herbivore_1.cage

            another_herbivore = create(:dinosaur, :herbivore)

            another_herbivore.update(cage: herbivore_1_cage)
            another_herbivore.reload
            expect(another_herbivore.cage).to eq(herbivore_1_cage)
          end
        end
      end

      describe 'max_capacity' do
        context 'when a cage is already at max capacity' do
          it 'does not allow the dinosaur to be assigned the cage' do
            cage_1 = create(:cage, max_capacity: 2)
            dinosaur_1 = create(:dinosaur, cage: cage_1)
            _dinosaur_2 = create(:dinosaur, species: dinosaur_1.species, cage: cage_1)

            # create a different caged dinosaur, then attempt move them into cage 1
            dinosaur_3 = create(:dinosaur, species: dinosaur_1.species)
            cage_1.reload # this reload is necessary for the validation to act correctly.
            dinosaur_3.update(cage: cage_1)

            expect(dinosaur_3.errors.full_messages).to include('Cannot move a dinosaur into a cage that is already at max capacity!')
            dinosaur_3.reload
            expect(dinosaur_3.cage).not_to eq(cage_1) # i.e. the change should NOT have persisted
          end
        end

        context 'when a cage has room (and does not violate any other validation)' do
          it 'allows the dinosaur to be assigned to the cage' do
            cage_1 = create(:cage, max_capacity: 3)
            dinosaur_1 = create(:dinosaur, cage: cage_1)
            _dinosaur_2 = create(:dinosaur, species: dinosaur_1.species, cage: cage_1)

            # create a different caged dinosaur, then move them into cage 1
            dinosaur_3 = create(:dinosaur, species: dinosaur_1.species)
            cage_1.reload # this reload is necessary for the validation to act correctly.

            dinosaur_3.update(cage: cage_1)

            dinosaur_3.reload
            expect(dinosaur_3.cage).to eq(cage_1) # i.e. the change should have persisted
          end
        end
      end

      describe 'moving carnivores into a cage with each other' do
        context 'when 1 or more carnivores of a different species are already in the cage' do
          it 'does not let them in' do
            carnivore_1, carnivore_2 = create_list(:dinosaur, 2, :carnivore)
            cage_1 = carnivore_1.cage

            # now, attempt to put them in the same cage
            carnivore_2.update(cage: cage_1)

            expect(carnivore_2.errors.full_messages).to include('Cannot move a carnivore into a cage with a carnivore of a different species!')
            carnivore_2.reload
            expect(carnivore_2.cage).not_to eq(cage_1) # i.e. the update should not have persisted.
          end
        end

        context 'when carnivore(s) of only the same species are in the cage' do
          it 'lets them in' do
            carnivore_species = create(:species, :carnivore)
            carnivore_1, carnivore_2 = create_list(:dinosaur, 2, species: carnivore_species)

            cage_1 = carnivore_1.cage

            # now, attempt to put them in the same cage
            carnivore_2.update(cage: cage_1)

            carnivore_2.reload
            expect(carnivore_2.cage).to eq(cage_1) # i.e. the change should have persisted.
          end
        end
      end
    end
  end
end