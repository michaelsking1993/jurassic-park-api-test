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
        some_cage = build(:cage)
        expect(some_cage).to be_valid

        some_cage.power_status = nil
        expect(some_cage).not_to be_valid
      end
    end

    context 'when powering down or activating a cage' do
      context 'when powering down a cage' do
        context 'when there are dinosaurs inside' do
          it 'does not allow powering down' do
            some_cage = create(:cage, power_status: POWER_STATUSES[:active])
            some_dinosaur = create(:dinosaur)

            some_cage.dinosaurs << some_dinosaur
            some_cage.update(power_status: POWER_STATUSES[:down])

            expect(some_cage.errors.full_messages).to include('Cannot power down a cage when dinosaurs are inside')
            some_cage.reload
            expect(some_cage.power_status).to eq(POWER_STATUSES[:active]) # i.e. cage should still be active, the change should not have persisted.
          end
        end

        context 'when there are NOT dinosaurs inside' do
          it 'allows powering down' do
            some_cage = create(:cage, power_status: POWER_STATUSES[:active])

            some_cage.update(power_status: POWER_STATUSES[:down])
            some_cage.reload
            expect(some_cage.power_status).to eq(POWER_STATUSES[:down]) # i.e. the change should have persisted.
          end
        end
      end
    end
  end
end