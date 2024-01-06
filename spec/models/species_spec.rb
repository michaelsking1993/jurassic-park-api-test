require 'rails_helper'

RSpec.describe Species do
  describe 'attributes' do
    it 'has the necessary columns' do
      expected_column_names = %w[title dietary_type]
      matching_column_names = Species.column_names & expected_column_names
      
      expect(matching_column_names.size).to eq(expected_column_names.size)
    end
  end


  describe 'validations' do
    context 'when adding a species' do
      it 'must have a dietary_type (herbivore, carnivore)' do

      end
    end
  end
end