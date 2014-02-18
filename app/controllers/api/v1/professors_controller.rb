class Api::V1::ProfessorsController < ApplicationController
  before_filter :authenticate_user!
  include Cache
  respond_to :json

  def search
    @professors = Professor.search(params[:q])
  end

  def show
    if params[:s] == "all"
      @professors = Professor.all
      @title = "All Professors"
    else
      subject = Subject.find(params[:s])
      @professors = subject.professors.distinct
      @title = "#{subject.name} Professors"
    end
    render :json => @professors.to_json({:methods => [:title, :average_course, :average_instruction, :average_learned, :average_challenged, :average_stimulated, :average_hours, :enrollment_count]})
  end
end
