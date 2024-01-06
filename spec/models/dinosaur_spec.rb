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
    context 'when adding a dinosaur' do
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
  end
end