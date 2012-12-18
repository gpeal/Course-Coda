class Api::V1::TitlesController < ApplicationController
  def search
    @titles = Title.search(params[:q])
    render :json => @titles.to_json({:only => [:id], :methods => [:to_s]})
  end
end
