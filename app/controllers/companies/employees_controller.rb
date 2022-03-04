module Companies
  class EmployeesController < Companies::BaseController
    before_action :set_employee, only: %i[show update destroy]
    def index
      @q = @company.employees.ransack(params[:q])
      @employees = @q.result.page(params[:page]).per(params[:per_page])
      data = EmployeeJbuilder.new(@employees).call
      render json: data, status: :ok
    end

    def show
      render json: EmployeeJbuilder.new(@employee).call, status: :ok
    end

    def create
      @employee = @company.employees.new(employee_params)
      if @employee.save
        render json: EmployeeJbuilder.new(@employee).call, status: :created
      else
        render json: { errors: @employee.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @employee.update(employee_params)
        render json: EmployeeJbuilder.new(@employee).call, status: :accepted
      else
        render json: { errors: @employee.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @employee.destroy
      head :no_content
    end

    private

    def set_employee
      @employee = @company.employees.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:name, :cpf, :email, :phone_number, :start_date, :end_date, :montly_salary,
                                       :occupation_id)
    end
  end
end
