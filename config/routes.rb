Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  constraints format: :json do
    resources :companies do
      scope module: :companies do
        resources :occupations
        resources :employees
      end
    end
  end
end
