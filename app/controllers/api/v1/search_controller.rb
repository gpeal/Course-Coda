class Api::V1::SearchController < ApplicationController
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
    overview = {}
    @sections.each do |section|
      first_year = section.year if section.year < first_year
      first_quarter = section.quarter if (section.year <= first_year &&
                                          section.quarter < first_quarter)
      key = "#{section.professor.to_s} #{section.to_s}"
      overview[key] = {professor: section.professor.to_s, title: section.title.to_s, instruction: [], course: [], learned: [], stimulated: [], challenged: [], hours: []} if overview[key].nil?
      overview[key][:instruction].push(section.instruction)
      overview[key][:course].push(section.course)
      overview[key][:learned].push(section.learned)
      overview[key][:stimulated].push(section.stimulated)
      overview[key][:challenged].push(section.challenged)
      overview[key][:hours].push(section.hours)
    end

    overview_arr = []
    overview.keys.each do |key|
      overview_arr.push({
        professor: overview[key][:professor],
        title: overview[key][:title],
        instruction: (overview[key][:instruction].inject{ |sum, el| sum + el }.to_f / overview[key][:instruction].size).round(2),
        course: (overview[key][:course].inject{ |sum, el| sum + el }.to_f / overview[key][:course].size).round(2),
        learned: (overview[key][:learned].inject{ |sum, el| sum + el }.to_f / overview[key][:learned].size).round(2),
        stimulated: (overview[key][:stimulated].inject{ |sum, el| sum + el }.to_f / overview[key][:stimulated].size).round(2),
        challenged: (overview[key][:challenged].inject{ |sum, el| sum + el }.to_f / overview[key][:challenged].size).round(2),
        hours: (overview[key][:hours].inject{ |sum, el| sum + el }.to_f / overview[key][:hours].size).round(2)
      })
    end

    render :json => {:sections => @sections, :xRange => {:firstQuarter => first_quarter, :firstYear => first_year}, :overview => overview_arr}
  end
end
