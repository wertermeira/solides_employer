class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy]
  def index
    @companies = Company.all
    data =  @companies.map { |company| CompanyJbuilder.new(company).call }
    render json: { data: data }
  end

  def show
    render json: { data: CompanyJbuilder.new(@company).call }
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      render json: { data: CompanyJbuilder.new(@company).call }, status: :created
    else
      render json: { errors: @company.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render json: { data: CompanyJbuilder.new(@company).call }, status: :accepted
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
