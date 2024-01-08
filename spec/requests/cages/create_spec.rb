require 'rails_helper'

RSpec.describe 'cages#create' do
  describe 'POST /cages' do
    context 'when the params passed are valid' do
      it 'creates a new cage' do
        valid_params = { max_capacity: 10, power_status: POWER_STATUSES[:down] }

        expect {
          post cages_path, params: { cage: valid_params }
        }.to change(Cage, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['max_capacity']).to eq(10)
      end
    end

    context 'when the params passed are invalid' do
      it 'returns an appropriate error code and message' do
        invalid_params = { max_capacity: 'invalid because I am not an integer', power_status: POWER_STATUSES[:active] }

        expect {
          post cages_path, params: { cage: invalid_params }
        }.not_to change(Cage, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Max capacity must be an integer')
      end
    end
  end
end
