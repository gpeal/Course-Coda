class Api::V1::SearchController < ApplicationController
  respond_to :json

  def query
    @sections = [Section.first, Section.last]
  end
end
