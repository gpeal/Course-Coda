class Title < ActiveRecord::Base
  attr_accessible :title

  has_many :sections
  has_many :subjects, :through => :sections

  def to_s
    "#{subject.abbrev} #{title}"
  end

  def subject
    subjects[0]
  end

  def course_num
    title.match(/\d\d\d-/)[0].split('-')[0]
  end

  def course_num_2
    title.match(/\d\d\d-\d/)[0]
  end

  def subject_abbrev
    subject.apprev
  end

  def self.search name
    keys = REDIS.keys("TITLE *#{name}*")
    ids = keys.collect {|key| key[-5..-1].to_i}
    find(ids)
  end
end
