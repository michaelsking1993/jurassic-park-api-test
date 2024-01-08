class SpeciesController < ApplicationController
  def index
    render json: Species.with_amount_in_park
  end

  def show
    @species = Species.with_amount_in_park
    @species = @species.find_by(id: params[:id]) || @species.find_by('lower(title) = ?', params[:id]&.downcase) # for title-searching

    if @species.present?
      render json: @species
    else
      render json: { error: 'Species not found' }, status: :not_found
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

  # def update
  #   @dinosaur = Dinosaur.find_by_id(params[:id])
  #
  #   if @dinosaur&.update(dinosaur_params)
  #     render json: @dinosaur
  #   elsif @dinosaur.blank?
  #     render json: { error: 'Dinosaur not found' }, status: :not_found
  #   else
  #     render json: { error: @dinosaur.errors.full_messages.join(', ') }, status: :unprocessable_entity
  #   end
  # end

  private

  def species_params
    params.require(:dinosaur).permit(:title, :dietary_type)
  end
end
