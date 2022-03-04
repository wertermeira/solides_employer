module Companies
  class OccupationsController < Companies::BaseController
    before_action :set_occupation, only: %i[show update destroy]

    def index
      @q = @company.occupations.ransack(params[:q])
      @occupations = @q.result.page(params[:page]).per(params[:per_page])
      data = OccupationJbuilder.new(@occupations).call
      render json: data, status: :ok
    end

    def show
      render json: OccupationJbuilder.new(@occupation).call, status: :ok
    end

    def create
      @occupation = @company.occupations.new(occupation_params)
      if @occupation.save
        render json: OccupationJbuilder.new(@occupation).call, status: :created
      else
        render json: { errors: @occupation.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @occupation.update(occupation_params)
        render json: OccupationJbuilder.new(@occupation).call, status: :accepted
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

    def occupation_params
      params.require(:occupation).permit(:name, :active)
    end
  end
end
