class Subject < ActiveRecord::Base
  attr_accessible :title

  has_many :sections
  has_many :professors, :through => :sections
  has_many :titles, :through => :sections

  def to_s
    title
  end

  def average type
    sections = Section.where(:subject_id => id)
    sum = 0
    enroll_count = 0
    sections.each do |s|
      sum = sum + s.send(type) * s.send(:"#{type}_enroll_count")
      enroll_count = enroll_count + s.send(:"#{type}_enroll_count")
    end
    return sum / enroll_count
  end

  def self.average type
    averages = []
    Subject.all.each do |s|
      ai = {}
      ai[:"average"] = s.send(:average, type)
      ai[:title] = s.title
      averages << ai
    end
    averages.sort! { |a,b| a[:"average_#{type}"] <=> b[:"average_#{type}"] }
  end

  def abbrev
    title.split(' ')[0]
  end

  def name
    title[title.index(' ') + 1..-1]
  end

  def self.find_by_abbrev abbrev
    subject = nil
    Subject.all.each { |s| subject = s if s.abbrev == abbrev }
    return subject
  end
end
