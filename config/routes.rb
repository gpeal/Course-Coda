CaesarScraper::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      match 'search' => 'search#search', :via => :post, :format => :json
      match 'professors/search' => 'professors#search', :via => :post, :format => :json

      match 'sections/search' => 'sections#search', :via => :post, :format => :json

      match 'titles/search' => 'titles#search', :via => :post, :format => :json

      match 'feedback/:id' => 'feedback#show', :via => :post, :format => :json
    end
  end

  root :to => 'home#index'
end
