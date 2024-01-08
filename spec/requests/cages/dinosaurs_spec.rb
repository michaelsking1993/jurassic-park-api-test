require 'rails_helper'

RSpec.describe 'cages#dinosaurs' do
  describe 'GET /cages/:cage_id/dinosaurs' do
    let(:cage) { create(:cage) }
    let(:species_1) { create(:species, dietary_type: DIETARY_TYPES[:herbivore]) }
    let(:species_2) { create(:species, dietary_type: DIETARY_TYPES[:herbivore]) }
    let(:dinosaur_1) { create(:dinosaur, species: species_1, cage: cage) }
    let(:dinosaur_2) { create(:dinosaur, species: species_2, cage: cage) }

    context 'when the cage is found' do
      it 'returns the dinosaurs inside of it' do
        get cage_dinosaurs_path(cage.id)

        expect(response).to have_http_status(:success)

        parsed_body = JSON.parse(response.body)
        expect(parsed_body.pluck('id')).to match_array([dinosaur_1.id, dinosaur_2.id])
        expect(parsed_body.pluck('name')).to match_array([dinosaur_1.name, dinosaur_2.name])
        expect(parsed_body.pluck('species_id')).to match_array([dinosaur_1.species_id, dinosaur_2.species_id])
      end
    end

    context 'when the cage cannot be found' do
      it 'returns an appropriate error code and message' do
        get cage_dinosaurs_path(999)

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Cage not found')
      end
    end
  end
end