module Companies
  class OccupationsController < ApplicationController
    before_action :set_company
    before_action :set_occupation, only: %i[show update destroy]

    def index
      @occupations = @company.occupations.all
      data = @occupations.map { |occupation| OccupationJbuilder.new(occupation).call }
      render json: { data: data }, status: :ok
    end

    def show
      render json: { data: OccupationJbuilder.new(@occupation).call }, status: :ok
    end

    def create
      @occupation = @company.occupations.new(occupation_params)
      if @occupation.save
        render json: { data: OccupationJbuilder.new(@occupation).call }, status: :created
      else
        render json: { errors: @occupation.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @occupation.update(occupation_params)
        render json: { data: OccupationJbuilder.new(@occupation).call }, status: :accepted
      else
        render json: { errors: @occupation.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @occupation.destroy
      head :no_content
    end

    private

    def set_occupation
      @occupation = @company.occupations.find(params[:id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def occupation_params
      params.require(:occupation).permit(:name, :active)
    end
  end
end
