class Section < ActiveRecord::Base
  # attr_accessible :instruction, :instruction_breakdown,  :instruction_responses, :instruction_enroll_count
  # attr_accessible :course, :course_breakdown, :course_responses, :course_enroll_count
  # attr_accessible :learned, :learned_breakdown, :learned_responses, :learned_enroll_count
  # attr_accessible :challenged, :challenged_breakdown, :challenged_responses, :challenged_enroll_count
  # attr_accessible :stimulated, :stimulated_breakdown, :stimulated_responses, :stimulated_enroll_count
  # attr_accessible :time_breakdown, :feedback, :school_breakdown, :class_breakdown, :reasons_breakdown, :interest_breakdown
  # attr_accessible :title_id

  belongs_to :professor
  belongs_to :quarter
  belongs_to :subject
  belongs_to :title
  belongs_to :year

  def course_num
    title.course_num
  end

  def course_num_2
    title.course_num_2
  end

  def subject_abbrev
    subject.abbrev
  end

  def hours
    hours = time_breakdown.scan(/\d+/) rescue [0, 100, 0, 0, 0, 0]
    hours[0].to_f / 100 * 2 + hours[1].to_f / 100 * 6 + hours[2].to_f / 100 * 10 + hours[3].to_f / 100 * 14 + hours[4].to_f / 100 * 18 + hours[5].to_f / 100 * 25
  end

  def as_json(options={})
    if options.member?(:only) or options.member?(:except) or options.member?(:include)
      return super(options)
    else
      return super(:only => [:id, :instruction, :course, :learned, :challenged, :stimulated],
                               :include => [:professor, :quarter, :subject, :title, :year],
                               :methods => [:hours])
    end
  end

  def to_s
    "#{subject.abbrev} #{title.to_s}"
  end

  def self.averages sections
    averages = {}
    sections.each do |section|
      key = "#{section.professor.to_s} #{section.to_s}"
      averages[key] = {professor: section.professor.to_s,
                       title: section.title.to_s,
                       instruction: [],
                       instruction_enroll_count: 0,
                       course: [],
                       course_enroll_count: 0,
                       learned: [],
                       learned_enroll_count: 0,
                       stimulated: [],
                       stimulated_enroll_count: 0,
                       challenged: [],
                       challenged_enroll_count: 0,
                       sentiment: [],
                       hours: []} if averages[key].nil?

      averages[key][:instruction].push(section.instruction * section.instruction_enroll_count)
      averages[key][:instruction_enroll_count] += section.instruction_enroll_count

      averages[key][:course].push(section.course * section.course_enroll_count)
      averages[key][:course_enroll_count] += section.course_enroll_count

      averages[key][:learned].push(section.learned * section.learned_enroll_count)
      averages[key][:learned_enroll_count] += section.learned_enroll_count

      averages[key][:stimulated].push(section.stimulated * section.stimulated_enroll_count)
      averages[key][:stimulated_enroll_count] += section.stimulated_enroll_count

      averages[key][:challenged].push(section.challenged * section.challenged_enroll_count)
      averages[key][:challenged_enroll_count] += section.challenged_enroll_count

      averages[key][:sentiment].push(Feedback.sentiment(section.id) * section.instruction_enroll_count)

      averages[key][:hours].push(section.hours * section.instruction_enroll_count)

    end

    averages_arr = []
    averages.keys.each do |key|
      averages_arr.push({
        professor: averages[key][:professor],
        title: averages[key][:title],
        instruction: (averages[key][:instruction].inject{ |sum, el| sum + el }.to_f / averages[key][:instruction_enroll_count]).round(2),
        course: (averages[key][:course].inject{ |sum, el| sum + el }.to_f / averages[key][:course_enroll_count]).round(2),
        learned: (averages[key][:learned].inject{ |sum, el| sum + el }.to_f / averages[key][:learned_enroll_count]).round(2),
        stimulated: (averages[key][:stimulated].inject{ |sum, el| sum + el }.to_f / averages[key][:stimulated_enroll_count]).round(2),
        challenged: (averages[key][:challenged].inject{ |sum, el| sum + el }.to_f / averages[key][:challenged_enroll_count]).round(2),
        sentiment: (averages[key][:sentiment].inject{ |sum, el| sum + el }.to_f / averages[key][:instruction_enroll_count]).round(2),
        hours: (averages[key][:hours].inject{ |sum, el| sum + el }.to_f / averages[key][:instruction_enroll_count]).round(2),
        responses: averages[key][:instruction_enroll_count]
      })
    end
    averages_arr
  end

  def self.average type, sections

  end

  def self.find_all name
    subject_abbrev = name.split(' ')[0]
    course_num = name.split(' ')[1]
    subject = Subject.find_by_abbrev(subject_abbrev)
    title = nil

    if subject.nil?
      return nil
    else
      sections = []
      if not name.match(/\S* \d\d\d-\d/).nil?
        subject.sections.each { |s| sections << s if s.course_num_2 == course_num }
      elsif not name.match(/\S* \d\d\d/).nil?
        subject.sections.each { |s| sections << s if s.course_num == course_num }
      end
      return sections
    end
  end

  def self.average type, section_name
    if section_name.nil?
      sections = Section.all
    else
      sections = find_all section_name
    end

    sum = 0
    enroll_count = 0
    sections.each do |s|
      sum = sum + s.send(type) * s.send("#{type}_enroll_count")
      enroll_count = enroll_count + s.send("#{type}_enroll_count")
    end
    return sum / enroll_count
  end

  def self.find_by_id id
    section = Section.where(:id => id)
    return section
  end

  def self.feedback name
    sections = find_all name
    feedback = []
    sections.each do |s|
      feedback << s.feedback.split('/')
    end
    return feedback
  end

  def self.search title
    keys = REDIS.keys("SECTION *#{title.split(' ').join('*')}*")
    ids = keys.collect {|key| REDIS.get(key)}
    ids.collect {|id| find(id)}
  end

  def self.find_by_query_params params
    sections = {}
    unless params[:p].nil?
      professor_ids = params[:p].split(',')
      sections[:p] = Section.where("professor_id in (#{professor_ids.join(',')})")
    end
    unless params[:t].nil?
      title_ids = params[:t].split(',')
      sections[:t] = Section.where("title_id in (#{title_ids.join(',')})")
    end

    sections_union = []
    unless sections.empty?
      sections_union = sections[sections.keys.first]
      sections.keys.each do |key|
        sections_union = sections_union & sections[key]
      end
    end


    return sections_union
  end
end
