require 'rails_helper'

RSpec.describe 'cages#index' do
  describe 'GET /cages' do
    let!(:active_cages) { create_list(:cage, 6, :active) }
    let!(:down_cages) { create_list(:cage, 3, :down) }
    let!(:dinosaur) { create(:dinosaur, cage: active_cages[0])} # just to show that the dinosaurs_contained counts are correct

    context 'when there are cages' do
      context 'when not requesting a filter by power_status' do
        it 'returns a list of all cages' do
          get dinosaurs_path

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          all_cages = [active_cages, down_cages].flatten

          expect(parsed_response.size).to eq(9)
          expect(parsed_response.pluck('id')).to match_array(all_cages.pluck(:id))
          expect(parsed_response.pluck('max_capacity')).to match_array(all_cages.pluck(:max_capacity))
        end
      end

      context 'when requesting a filter by power_status' do
        context 'when requesting those with power_status of active' do
          it 'returns only those cages that are active' do
            get dinosaurs_path(power_status: POWER_STATUSES[:active])

            expect(response).to have_http_status(:success)
            parsed_response = JSON.parse(response.body)

            expect(parsed_response.size).to eq(6)
            expect(parsed_response.pluck('id')).to match_array(active_cages.pluck(:id))
            expect(parsed_response.pluck('max_capacity')).to match_array(active_cages.pluck(:max_capacity))
            expect(parsed_response.pluck('dinosaurs_contained')).to match_array([1, 0, 0, 0, 0, 0])
          end
        end

        context 'when requesting those with power_status of down' do
          it 'returns only those cages that are powered down' do
            get dinosaurs_path(power_status: POWER_STATUSES[:down])

            expect(response).to have_http_status(:success)
            parsed_response = JSON.parse(response.body)

            expect(parsed_response.size).to eq(3)
            expect(parsed_response.pluck('id')).to match_array(down_cages.pluck(:id))
            expect(parsed_response.pluck('max_capacity')).to match_array(down_cages.pluck(:max_capacity))
            expect(parsed_response.pluck('dinosaurs_contained')).to match_array([0, 0, 0])
          end
        end
      end
    end

    context 'when there are not cages' do
      it 'returns an empty array' do
        get dinosaurs_path

        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq([])
      end
    end
  end
end