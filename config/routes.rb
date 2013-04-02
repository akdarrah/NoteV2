Note::Application.routes.draw do
  root :to => "root#index"

  resources :artists do
    resources :albums do
      resources :tracks
    end
  end

end
