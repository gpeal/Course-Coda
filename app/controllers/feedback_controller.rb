class FeedbackController < ApplicationController

  def search
    @feedback = Feedback.where(section_id: params[:s])
    render :json => @feedback
  end
end
