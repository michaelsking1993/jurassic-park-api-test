require 'rails_helper'

RSpec.describe 'dinosaurs#update' do
  describe 'PATCH /dinosaurs/:id' do
    let(:dinosaur) { create(:dinosaur, name: 'Old Name') }

    context 'with valid parameters' do
      it 'updates a dinosaur' do
        updated_name = 'THIS IS A NEW NAME!'
        updated_cage = create(:cage)
        updated_species = create(:species)

        updated_attributes = { name: updated_name, species_id: updated_species.id, cage_id: updated_cage.id }

        patch dinosaur_path(dinosaur.id), params: { dinosaur: updated_attributes }

        expect(response).to have_http_status(:success)

        expect(JSON.parse(response.body)).to include(updated_attributes.stringify_keys)
        dinosaur.reload
        expect(dinosaur.name).to eq(updated_name)
        expect(dinosaur.cage_id).to eq(updated_cage.id)
        expect(dinosaur.species_id).to eq(updated_species.id)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        patch "/dinosaurs/#{dinosaur.id}", params: { dinosaur: { species_id: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Species must exist')
      end
    end

    context 'when the dinosaur is not found' do
      it 'returns an error' do
        patch dinosaur_path(999), params: { dinosaur: { name: 'Updated Name' } }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Dinosaur not found')
      end
    end
  end
end