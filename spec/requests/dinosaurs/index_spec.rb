require 'rails_helper'

RSpec.describe 'dinosaurs#index' do
  describe 'GET /dinosaurs' do
    context 'when there are dinosaurs' do
      let(:herbivore_species_1) { create(:species, dietary_type: DIETARY_TYPES[:herbivore])}
      let(:herbivore_species_2) { create(:species, dietary_type: DIETARY_TYPES[:herbivore])}
      let(:carnivore_species_1) { create(:species, dietary_type: DIETARY_TYPES[:carnivore])}
      let(:carnivore_species_2) { create(:species, dietary_type: DIETARY_TYPES[:carnivore])}

      let(:herbivore_dino_1) { create(:dinosaur, species: herbivore_species_1) }
      let(:herbivore_dino_2) { create(:dinosaur, species: herbivore_species_2) }
      let(:carnivore_dino_1) { create(:dinosaur, species: carnivore_species_1) }
      let(:carnivore_dino_2) { create(:dinosaur, species: carnivore_species_2) }
      let(:carnivore_dino_3) { create(:dinosaur, species: carnivore_species_2) } # so that there are are 2 dinosaurs of this same carnivore species

      context 'when not requesting a filter by species' do
        it 'returns a list of all dinosaurs' do
          get dinosaurs_path

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          all_dinosaurs = Dinosaur.all

          expect(parsed_response.size).to eq(5)

          expect(parsed_response.pluck('id', 'name', 'species_id')).to match_array(all_dinosaurs.pluck(:id, :name, :species_id))

          # expect(parsed_response.pluck('id')).to match_array(all_dinosaurs.pluck(:id))
          # expect(parsed_response.pluck('name')).to match_array(all_dinosaurs.pluck(:name))
          # expect(parsed_response.pluck('species_id')).to match_array(all_dinosaurs.pluck(:species_id))
        end
      end

      context 'when requesting a filter by species' do
        context 'when the species exists' do
          it 'returns only dinosaurs of that species' do
            get dinosaurs_path(species_id: carnivore_species_2.id)

            expect(response).to have_http_status(:success)
            parsed_response = JSON.parse(response.body)

            expect(parsed_response.size).to eq(2)
            carnivore_species_2_dinos = [carnivore_dino_2, carnivore_dino_3]

            expect(parsed_response.pluck('id', 'name', 'species_id')).to match_array(carnivore_species_2_dinos.pluck(:id, :name, :species_id))

            # expect(parsed_response.pluck('id')).to match_array(active_dinosaurs.pluck(:id))
            # expect(parsed_response.pluck('max_capacity')).to match_array(active_dinosaurs.pluck(:max_capacity))
            # expect(parsed_response.pluck('dinosaurs_contained')).to match_array([1, 0, 0, 0, 0, 0])
          end
        end

        context 'when the species does not exist' do
          it 'returns an error message' do
            get dinosaurs_path(species_id: 9999999999999999)

            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)['error']).to eq('Species not found')
          end
        end
      end
    end

    context 'when there are not dinosaurs' do
      it 'returns an empty array' do
        get dinosaurs_path

        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq([])
      end
    end
  end
end