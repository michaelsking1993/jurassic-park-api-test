require 'rails_helper'

RSpec.describe 'dinosaurs#create' do
  describe 'POST /dinosaurs' do

    let(:species) { create(:species) }
    let(:cage) { create(:cage) }

    context 'when the params passed are valid' do
      it 'creates a new cage' do
        valid_params = { name: 'Michael King', species_id: species.id, cage_id: cage.id }

        expect {
          post dinosaurs_path, params: { cage: valid_params }
        }.to change(Dinosaur, :count).by(1)

        expect(response).to have_http_status(:created)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to include({
          'name' => 'Michael King',
          'species_id' => species.id,
          'cage_id' => cage.id
        })
      end
    end

    context 'when the params passed are invalid' do
      it 'returns an appropriate error code and message' do
        invalid_params = { name: '', species_id: species.id, cage_id: cage.id }

        expect {
          post '/dinosaurs', params: { cage: invalid_params }
        }.not_to change(Dinosaur, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Name can\'t be blank')
      end
    end
  end
end
