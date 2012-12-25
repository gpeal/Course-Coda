class Title < ActiveRecord::Base
  attr_accessible :title, :title_id

  has_many :sections
  has_many :subjects, :through => :sections

  def to_s
    "#{subject.abbrev} #{title}"
  end

  def subject
    subjects[0]
  end

  def course_num
    title.match(/[0-9A-Z]*/)[0]
  end

  def course_num_2
    title.match(/[0-9A-Z]*-[0-9A-Z]*/)[0]
  end

  def third_course_num
    third_course_num.split('-')[2]
  end

  def name
    title.sub(course_num_2 + ' ', '')
  end

  def subject_abbrev
    subject.apprev
  end

  def average
    overview = {instruction: [], course: [], learned: [], stimulated: [], challenged: [], hours: []}
    sections.each do |section|
      overview[:instruction].push(section.instruction)
      overview[:course].push(section.course)
      overview[:learned].push(section.learned)
      overview[:stimulated].push(section.stimulated)
      overview[:challenged].push(section.challenged)
      overview[:hours].push(section.hours)
    end

    overview[:instruction] = (overview[:instruction].inject{ |sum, el| sum + el }.to_f / overview[:instruction].size).round(2)
    overview[:course] = (overview[:course].inject{ |sum, el| sum + el }.to_f / overview[:course].size).round(2)
    overview[:learned] = (overview[:learned].inject{ |sum, el| sum + el }.to_f / overview[:learned].size).round(2)
    overview[:stimulated] = (overview[:stimulated].inject{ |sum, el| sum + el }.to_f / overview[:stimulated].size).round(2)
    overview[:challenged] = (overview[:challenged].inject{ |sum, el| sum + el }.to_f / overview[:challenged].size).round(2)
    overview[:hours] = (overview[:hours].inject{ |sum, el| sum + el }.to_f / overview[:hours].size).round(2)
    overview
  end

  def average_instruction
    average = []

    sections.each do |section|
      average.push(section.instruction)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_course
    average = []

    sections.each do |section|
      average.push(section.course)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_learned
    average = []

    sections.each do |section|
      average.push(section.learned)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_stimulated
    average = []

    sections.each do |section|
      average.push(section.stimulated)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_challenged
    average = []

    sections.each do |section|
      average.push(section.challenged)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_hours
    average = []

    sections.each do |section|
      average.push(section.hours)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def self.search name
    keys = REDIS.keys("TITLE *#{name.split(' ').join('*')}*")
    ids = keys.collect {|key| key[-5..-1].to_i}
    find(ids)
  end
end
