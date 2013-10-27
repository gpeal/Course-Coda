class TitlesController < ApplicationController

  def show
    if params[:s] == "all"
      @title = "All Subjects"
    else
      subject = Subject.find(params[:s])
      @title = subject.name
    end
  end

end
