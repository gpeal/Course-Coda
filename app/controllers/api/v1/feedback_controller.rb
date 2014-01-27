class Api::V1::FeedbackController < ApplicationController
  include Cache

  def show
    feedback = Feedback.where(section_id: params[:id]).sort!
    keywords = Feedback.keywords params[:id]
    sentiment = Feedback.sentiment params[:id]

    json = {:feedback => feedback, :keywords => keywords, :sentiment => sentiment}.to_json
    render :json => json
  end
end
