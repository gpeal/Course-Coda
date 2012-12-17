class Api::V1::SearchController < ApplicationController
  respond_to :json

  def search
    @sections = Section.find_by_query_params params
    #sort the sections by time (helps on the client side javascript end of things)
    seasons_hash = {'Winter' => 0, 'Spring' => 1, 'Summer' => 2, 'Fall' => 3}
    @sections.sort_by! {|s| [s.year.title, seasons_hash[s.quarter.to_s]]}
    respond_to do |format|
      format.json {render :json => @sections}
    end
  end
end
