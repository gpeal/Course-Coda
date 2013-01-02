class Api::V1::FeedbackController < ApplicationController

  def show
    feedback = Feedback.where(section_id: params[:id]).sort!
    keywords = Feedback.keywords params[:id]
    sentiment = Feedback.sentiment params[:id]
    render :json => {:feedback => feedback, :keywords => keywords, :sentiment => sentiment}
  end
end
