class Api::V1::SearchController < ApplicationController
  before_filter :authenticate_user!
  include Cache
  respond_to :json

  def search
    @sections = Section.find_by_query_params params
    if @sections.count > 200
      render :json => {:error => 'Search yielded too many sections. Try narrowing your search options.'}
      return
    elsif @sections.empty?
      render :json => {:info => 'Search returned no courses. Try broadening your search options.'}
      return
    end

    first_year = @sections[0].year unless @sections.nil?
    first_quarter = @sections[0].quarter unless @sections.nil?
    @sections.each do |section|
          first_year = section.year if section.year < first_year
          first_quarter = section.quarter if (section.year <= first_year &&
                                              section.quarter < first_quarter)
    end

    averages = Section.averages @sections
    render :json => {:sections => @sections, :xRange => {:firstQuarter => first_quarter, :firstYear => first_year}, :averages => averages}
  end
end
