class Api::V1::FeedbackController < ApplicationController

  def show
    feedback = Feedback.where(section_id: params[:id]).sort!
    key = "FEEDBACK_KEYWORDS #{params[:id]}"
    result = REDIS.get(key)
    if result.nil?
      text = feedback.collect(&:feedback).join(' ')
      result = ALCHEMY.TextGetRankedKeywords(text, AlchemyAPI::OutputMode::JSON)
      REDIS.set(key, result)
    end
    result = JSON.parse(result)

    keywords = result['keywords'].collect {|k| k['text']}

    professor_name = feedback.first.section.professor.title rescue 'dummy name'
    keywords = (keywords - ['course', 'class', 'professor', 'teacher', 'time', 'things', 'students',
                            'lecture', 'lectures', 'book', 'books', 'material', 'materials', 'test', 'tests',
                            'time', 'times', 'questions', 'problem', 'problems',
                            professor_name, professor_name.split(' ')[0].downcase, professor_name.split(' ')[1].downcase])[0..20]
    render :json => {:feedback => feedback, :keywords => keywords}
  end
end
