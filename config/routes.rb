Rails.application.routes.draw do
  resources :shipments, only: %i[show], format: :json, param: :strategy
end
