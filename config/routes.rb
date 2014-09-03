CanadaCensus::Application.routes.draw do
  get "/" => "templates#census_tracts"

  namespace :api do
    namespace :v1 do
      resources :census_tracts
    end
  end
end
