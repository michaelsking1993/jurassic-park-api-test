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
    @species = Species.new(species_params)

    if @species.save
      render json: @species, status: :created
    else
      render json: { error: @species.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def update
    @species = Species.find_by_id(params[:id])

    if @species&.update(species_params)
      render json: @species
    elsif @species.blank?
      render json: { error: 'Species not found' }, status: :not_found
    else
      render json: { error: @species.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def species_params
    params[:species][:dietary_type]&.strip!
    params[:species][:dietary_type]&.downcase!
    params.require(:species).permit(:title, :dietary_type)
  end
end
