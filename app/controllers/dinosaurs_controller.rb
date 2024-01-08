class DinosaursController < ApplicationController
  def index
    @dinosaurs = Dinosaur.with_species_name

    if params[:species_id].present?
      # species filter
      if (species = Species.find_by_id(params[:species_id])).present?
        render json: @dinosaurs.where(species_id: species.id)
      else
        render json: { error: 'Species not found' }, status: :not_found
      end
    else
      # no filter
      render json: @dinosaurs
    end
  end

  def show
    @dinosaur = Dinosaur.with_species_name.find_by_id(params[:id])

    if @dinosaur.present?
      render json: @dinosaur
    else
      render json: { error: 'Dinosaur not found' }, status: :not_found
    end
  end

  def create
    @dinosaur = Dinosaur.new(dinosaur_params)

    if @dinosaur.save
      render json: @dinosaur, status: :created
    else
      render json: { error: @dinosaur.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    @dinosaur = Dinosaur.find_by_id(params[:id])

    if @dinosaur&.update(dinosaur_params)
      render json: @dinosaur
    elsif @dinosaur.blank?
      render json: { error: 'Dinosaur not found' }, status: :not_found
    else
      render json: { error: @dinosaur.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def dinosaur_params
    params.require(:dinosaur).permit(:name, :species_id, :cage_id)
  end
end
