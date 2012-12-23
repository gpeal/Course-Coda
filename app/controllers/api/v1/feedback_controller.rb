class Api::V1::FeedbackController < ApplicationController

  def show
    @feedback = Feedback.where(section_id: params[:id]).sort!
    render :json => @feedback
  end
end
