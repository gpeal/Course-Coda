class Feedback < ActiveRecord::Base
  # attr_accessible :feedback, :section_id, :sentiment
  validates :feedback, :presence => true

  belongs_to :section

  def as_json(options={})
    if options.member?(:only) or options.member?(:except) or options.member?(:include)
      return super(options)
    else
      return super(:only => [:id, :feedback])
    end
  end

  def <=>(other)
    return other.feedback.length <=> self.feedback.length
  end

  def self.keywords section_id
    key = "FEEDBACK_KEYWORDS #{section_id}"
    keywords = CACHE.get(key)
    if keywords.nil?
      text = where(section_id: section_id).collect(&:feedback).join(' ')
      return [] if text.empty?
      begin
        result = AlchemyAPI::KeywordExtraction.new.search(text: text)
        keywords = result.collect {|k| k['text']}
        CACHE.set(key, keywords)
      rescue => err
        logger.error "Unable to get alchemy keywords (#{err})"
        keywords = []
      end
    else
      logger.info "Returning Alchemy keywords from cache"
    end

    professor_name = Section.find(section_id).professor.title rescue 'dummy name'
    (keywords - ['course', 'class', 'professor', 'teacher', 'time', 'things', 'students',
                            'lecture', 'lectures', 'book', 'books', 'material', 'materials', 'test', 'tests',
                            'time', 'times', 'questions', 'problem', 'problems',
                            professor_name, professor_name.split(' ')[0], professor_name.split(' ')[1],
                            professor_name.downcase, professor_name.split(' ')[0].downcase, professor_name.split(' ')[1].downcase])[0..20]
  end

  def self.sentiment section_id
    key = "FEEDBACK_SENTIMENT #{section_id}"
    result = REDIS.get(key)
    if result.nil?
      text = where(section_id: section_id).collect(&:feedback).join(' ')
      return 0 if text.empty?
      result = ALCHEMY.TextGetTextSentiment(text, AlchemyAPI::OutputMode::JSON)
      REDIS.set(key, result) if JSON.parse(result)['status'] == 'OK'
    end
    result = JSON.parse(result)
    score = (result['docSentiment']['score'].to_f * 100).to_i
    score += 25
    score *= 2
    score = 100 if score > 100
    score = 0 if score < 0
    score
  end
end
