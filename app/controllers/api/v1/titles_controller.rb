class Api::V1::TitlesController < ApplicationController
  def search
    @titles = Title.search(params[:q])
    render :json => @titles.to_json({:only => [:id], :methods => [:to_s]})
  end

  def show
    @titles = Subject.find(params[:id]).titles
    render :json => @titles.to_json({:only => [:title], :methods => [:average]})
  end
end
