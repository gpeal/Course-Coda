class Title < ActiveRecord::Base
  attr_accessible :title

  def to_s
    title
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
end
