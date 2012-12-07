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
    #sort the sections by time (helps on the client side javascript end of things)
    seasons_hash = {'Winter' => 0, 'Spring' => 1, 'Summer' => 2, 'Fall' => 3}
    @sections.sort_by! {|s| [s.year.title, seasons_hash[s.quarter.to_s]]}
  end
end
