Rails.application.routes.draw do
  resources :jerseys, only: :index
  resources :uniforms, only: :index
  get :home_jerseys, to: 'jerseys#home_jerseys'
end
