class Api::V1::ProfessorsController < ApplicationController
  respond_to :json

  def search
    @professors = Professor.search(params[:q])
    # binding.pry
    render :json => @professors
  end

  def show
    @professors = Subject.find(params[:s]).professors.uniq!
    render :json => @professors.to_json({:methods => [:title, :average_course, :average_instruction, :average_learned, :average_challenged, :average_stimulated, :average_hours]})
  end
end
