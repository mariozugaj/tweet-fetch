Rails.application.routes.draw do
  root to: 'tweets#index'

  resource :tweets, only: [:index] do
    get :pagination
  end
end
