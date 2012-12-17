class Api::V1::ProfessorsController < ApplicationController
  respond_to :json

  def search
    @professors = Professor.search(params[:q])
    # binding.pry

    render :json => @professors
  end
end
