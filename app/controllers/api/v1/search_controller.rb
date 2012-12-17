class Api::V1::SearchController < ApplicationController
  respond_to :json

  def search
    begin
      @sections = Section.find_by_query_params params
    rescue Exceptions::TooManySections
      redirect_to root_url + '?p=1', :alert => 'Search returned too many sections. Try narrowing your search terms.'
      return
    end
    first_year = @sections[0].year unless @sections.nil?
    first_quarter = @sections[0].quarter unless @sections.nil?
    @sections.each do |section|
      first_year = section.year if section.year < first_year
      first_quarter = section.quarter if (section.year <= first_year &&
                                          section.quarter < first_quarter)
    end

    respond_to do |format|
      format.json {render :json => {:sections => @sections, :xRange => {:firstQuarter => first_quarter, :firstYear => first_year}}}
    end
  end
end
