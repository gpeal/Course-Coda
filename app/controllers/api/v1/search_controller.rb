class Api::V1::SearchController < ApplicationController
  respond_to :json

  def search
    @sections = Section.find_by_query_params params

    first_year = @sections[0].year unless @sections.empty?
    first_quarter = @sections[0].quarter unless @sections.empty?
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
