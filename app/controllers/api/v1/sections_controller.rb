class Api::V1::SectionsController < ApplicationController

  def search
    @sections = Section.search(params[:q])
    render :json => @sections.to_json({:only => [:id], :methods => [:to_s]})
  end

end
