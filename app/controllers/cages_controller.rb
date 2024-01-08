class CagesController < ApplicationController
  def index
    @cages = Cage.with_dinosaurs_contained

    if (power_status = params[:power_status]&.downcase).present?
      # power status filter
      if power_status.in?(POWER_STATUSES.values)
        @cages = @cages.where(power_status: params[:power_status])
        render json: @cages
      else
        render json: { error: 'Power status not found' }, status: :not_found
      end
    else
      # no filter
      render json: @cages
    end
  end

  def show
    @cage = Cage.with_dinosaurs_contained.find_by(id: params[:id])

    if @cage.present?
      render json: @cage
    else
      render json: { error: 'Cage not found' }, status: :not_found
    end
  end

  def dinosaurs
    @cage = Cage.find_by_id(params[:cage_id])

    if @cage.blank?
      render json: { error: 'Cage not found' }, status: :not_found
    else
      render json: @cage.dinosaurs.with_species_name
    end
  end

  def create
    @cage = Cage.new(cage_params)

    if @cage.save
      render json: @cage, status: :created
    else
      render json: { error: @cage.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    @cage = Cage.find_by_id(params[:id])

    if @cage&.update(cage_params)
      render json: @cage
    elsif @cage.blank?
      render json: { error: 'Cage not found' }, status: :not_found
    else
      render json: { error: @cage.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def cage_params
    params.require(:cage).permit(:max_capacity, :power_status)
  end
end