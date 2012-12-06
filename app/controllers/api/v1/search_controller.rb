class Api::V1::SearchController < ApplicationController
  respond_to :json

  def search
    if params[:p].nil?
      professors = []
    elsif params[:p].include?(',')
      professors = params[:p].split(',')
    else
      professors = [params[:p]]
    end
    professors.collect! {|p_id| Professor.find(p_id)}
    @sections = []
    professors.each do |p|
      @sections.concat(p.sections)
    end
    # @sections = {:sections => @sections}
  end
end
