Rails.application.routes.draw do
  root 'tweets#index'
  get '/tweets', to: 'tweets#index', as: :tweets
end
