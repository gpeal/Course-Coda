CaesarScraper::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'query', :to => 'search#query'
    end
  end

  root :to => 'home#index'
end
