require 'rails_helper'

RSpec.describe 'cages#dinosaurs' do
  describe 'GET /cages/:cage_id/dinosaurs' do
    let(:cage) { create(:cage) }
    let(:species1) { create(:species, dietary_type: DIETARY_TYPES[:herbivore]) }
    let(:species2) { create(:species, dietary_type: DIETARY_TYPES[:herbivore]) }
    let!(:dinosaur1) { create(:dinosaur, species: species1, cage: cage) }
    let!(:dinosaur2) { create(:dinosaur, species: species2, cage: cage) }

    context 'when the cage is found' do
      it 'returns the dinosaurs inside of it' do
        get cage_dinosaurs_path(cage.id)

        expect(response).to have_http_status(:success)

        parsed_body = JSON.parse(response.body)
        dinos = Dinosaur.where(id: [dinosaur1.id, dinosaur2.id]).joins(:species)

        expect(parsed_body.pluck('id', 'name', 'species_id', 'species_name')).to match_array(dinos.pluck(:id, :name, :species_id, 'species.title'))
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
