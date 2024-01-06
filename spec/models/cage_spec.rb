require 'rails_helper'

RSpec.describe Cage do
  describe 'attributes' do
    it 'has the necessary columns' do
      expected_column_names = %w[max_capacity power_status]
      matching_column_names = Cage.column_names & expected_column_names

      expect(matching_column_names.size).to eq(expected_column_names.size)
    end
  end


  describe 'validations' do
    context 'when adding a cage' do
      it 'must have a power_status' do

      end
    end

    context 'when powering down a cage' do
      it 'does not allow powering down if there are dinosaurs inside' do

      end
    end

    context 'when moving dinosaurs into a cage' do
      it 'does not allow them to be moved in if the cage is powered down' do

      end

      it 'does not allow herbivores to be in the same cage as carnivores' do

      end

      it 'only allows carnivores to be in a cage with other dinosaurs of the same species' do

      end
    end
  end
end