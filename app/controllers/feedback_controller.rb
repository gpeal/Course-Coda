class FeedbackController < ApplicationController

  def search
    @feedback = Feedback.where(section_id: params[:s]).sort!
    render :json => @feedback
  end
end
