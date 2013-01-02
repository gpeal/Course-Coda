class Api::V1::TitlesController < ApplicationController
  respond_to :json

  def search
    @titles = Title.search(params[:q])
    render :json => @titles.to_json({:only => [:id], :methods => [:to_s]})
  end

  def show
    @titles = Subject.find(params[:s]).titles.uniq!
    render :json => @titles.to_json({:methods => [:course_num_2, :name, :average_course, :average_instruction, :average_learned, :average_challenged, :average_stimulated, :average_hours, :enrollment_count]})
  end
end
