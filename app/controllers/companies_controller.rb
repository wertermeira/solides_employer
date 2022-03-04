class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy]
  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.page(params[:page]).per(params[:per_page])
    data = CompanyJbuilder.new(@companies).call
    render json: data, status: :ok
  end

  def show
    render json: CompanyJbuilder.new(@company).call, status: :ok
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      render json: CompanyJbuilder.new(@company).call, status: :created
    else
      render json: { errors: @company.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render json: CompanyJbuilder.new(@company).call, status: :accepted
    else
      render json: { errors: @company.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :cnpj, :email)
  end
end
