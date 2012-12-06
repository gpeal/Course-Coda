class Api::V1::SearchController < ApplicationController
  respond_to :json

  def query
    @professors = Professor.search(params[:q])
  end
end
