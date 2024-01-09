Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # root "posts#index"

  resources :dinosaurs, except: %i[edit destroy]
  resources :cages, except: %i[edit destroy] do
    # resources :dinosaurs, only: [:index]
    get 'dinosaurs', to: 'cages#dinosaurs', as: :dinosaurs # a list of dinosaurs inside of a given cage.
    get 'species', to: 'cages#species', as: :species # a list of species inside a cage (for internal testing)
  end

  resources :species, except: %i[edit destroy] # Not part of project reqs, just for easier querying in postman and for playing around with the app
end
