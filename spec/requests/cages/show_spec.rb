require 'rails_helper'

RSpec.describe 'cages#show' do
  describe 'GET /cages/:id' do
    context 'when the cage exists' do
      let(:cage) { create(:cage, max_capacity: 3) }
      let!(:dinosaur_1) { create(:dinosaur, cage: cage) }
      let!(:dinosaur_2) { create(:dinosaur, species: dinosaur_1.species, cage: cage ) }

      it 'returns a specific cage, including how many dinosaurs it contains' do
        get cage_path(cage.id)

        expect(response).to have_http_status(:success)

        expected_body = {
          'id' => cage.id,
          'max_capacity' => 3,
          'power_status' => POWER_STATUSES[:active],
          'dinosaurs_contained' => 2
        }

        expect(JSON.parse(response.body)).to include(expected_body)
      end
    end

    context 'when the cage does not exist' do
      it 'returns an appropriate error code' do
        get cage_path(9999)

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Cage not found')
      end
    end
  end
end