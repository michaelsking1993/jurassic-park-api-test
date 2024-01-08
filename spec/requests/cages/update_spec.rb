require 'rails_helper'

RSpec.describe 'cages#update' do
  describe 'PATCH /cages/:id' do
    let(:cage) { create(:cage, max_capacity: 10, power_status: POWER_STATUSES[:active]) }

    context 'with valid parameters' do
      it 'updates a cage' do
        patch cage_path(cage.id), params: { cage: { max_capacity: 20, power_status: POWER_STATUSES[:down] } }

        expect(response).to have_http_status(:success)

        expected_body = { 'id' => cage.id, 'max_capacity' => 20, 'power_status' => POWER_STATUSES[:down]}

        expect(JSON.parse(response.body)).to include(expected_body)

        cage.reload
        expect(cage.max_capacity).to eq(20)
        expect(cage.power_status).to eq(POWER_STATUSES[:down])
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        patch cage_path(cage.id), params: { cage: { max_capacity: 'Not an integer' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Max capacity must be an integer')
      end
    end

    context 'when the cage is not found' do
      it 'returns an error' do
        patch cage_path(999), params: { cage: { max_capacity: 30 } }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Cage not found')
      end
    end
  end
end
