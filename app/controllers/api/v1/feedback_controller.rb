class Api::V1::FeedbackController < ApplicationController
  include Cache

  def show
    key = "FEEDBACK id#{params[:id]}"
    json = CACHE.get(key)
    unless json.nil?
      render :json => json
      return
    end

    feedback = Feedback.where(section_id: params[:id]).sort!
    keywords = Feedback.keywords params[:id]
    sentiment = Feedback.sentiment params[:id]

    json = {:feedback => feedback, :keywords => keywords, :sentiment => sentiment}.to_json
    CACHE.set(key, json)
    render :json => json
  end
end
