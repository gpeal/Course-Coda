CaesarScraper::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'search', :to => 'search#search'
      namespace :professors do
        post 'search'
      end
    end
  end

  root :to => 'home#index'
end
