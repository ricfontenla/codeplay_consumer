Rails.application.routes.draw do
  root 'home#index'
  resources :courses, only: [:show, :new, :create], param: :code
end
