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

  end
end