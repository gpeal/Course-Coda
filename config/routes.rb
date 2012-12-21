CaesarScraper::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'search', :to => 'search#search'
      namespace :professors do
        post 'search'
      end

      namespace :sections do
        post 'search'
      end

      namespace :titles do
        post 'search'
      end

      namespace :feedback do
        post 'search'
      end
    end
  end

  root :to => 'home#index'
end
