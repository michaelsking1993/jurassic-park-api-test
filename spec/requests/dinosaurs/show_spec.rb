require 'rails_helper'

RSpec.describe 'dinosaurs#show' do
  describe 'GET /dinosaurs/:id' do
    context 'when the dinosaurs exists' do
      let(:dinosaur) { create(:dinosaur) }

      it 'returns a specific dinosaurs' do
        get dinosaur_path(dinosaur.id)

        expect(response).to have_http_status(:success)

        expected_response = {
          'id' => dinosaur.id,
          'name' => dinosaur.name,
          'species_name' => dinosaur.species.title,
          'cage_id' => dinosaur.cage_id
        }

        expect(JSON.parse(response.body)).to include(expected_response)
      end
    end

    context 'when the dinosaur does not exist' do
      it 'returns an appropriate error code' do
        get dinosaur_path(999)

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Dinosaur not found')
      end
    end
  end
end
