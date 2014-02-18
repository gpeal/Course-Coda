class Api::V1::TitlesController < ApplicationController
  before_filter :authenticate_user!
  include Cache
  respond_to :json

  def search
    @titles = Title.search(params[:q])
  end

  def show
    if params[:s] == "all"
      @titles = Title.all
      @titles.delete_if {|t| t.responses < 10}
    else
      subject = Subject.find(params[:s])
      @titles = subject.titles.distinct
    end
    render :json => @titles.to_json({:methods => [:course_num_2, :to_s, :average_course, :average_instruction, :average_learned, :average_challenged, :average_stimulated, :average_hours, :enrollment_count]})
  end
end
