class Professor < ActiveRecord::Base
  attr_accessible :title
  has_many :sections

  def to_s
    title
  end

  def average type = nil
    if type.nil?
      print "instruction:"
      puts average "instruction"
      print "course:"
      puts average "course"
      print "learned:"
      puts average "learned"
      print "challenge:"
      puts average "challenge"
      print "stimulation:"
      puts average "stimulation"
      return
    end
    sum = 0
    enroll_count = 0
    sections.each do |s|
      sum = sum + s.send(type) * s.send("#{type}_enroll_count")
      enroll_count = enroll_count + s.send("#{type}_enroll_count")
    end
    return sum / enroll_count
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

  # def as_json(options={})
  #   self.include_root_in_json = false
  #   super(:only => [:id, :title])
  # end

  def self.find_by_name name
    professor = Professor.where('title LIKE ?', "%#{name}%").first
  end

  def self.search name
    keys = REDIS.keys("PROFESSOR *#{name.split(' ').join('*')}*")
    ids = keys.collect {|key| key[-5..-1].to_i}
    find(ids)
  end
end
