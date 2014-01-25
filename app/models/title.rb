class Title < ActiveRecord::Base
  include Averages

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
    subject.abbrev
  end

  def overview
      Section.overview sections
  end

  def responses
    sections.sum {|s| s.instruction_responses}
  end

  def self.search name
    rows = ActiveRecord::Base.connection.exec_query('SELECT "titles"."id", (string_to_array("subjects"."title", \' \'))[1] || \' \' || "titles"."title"  FROM "subjects" INNER JOIN "sections" ON "subjects"."id" = "sections"."subject_id" INNER JOIN "titles" ON "sections"."title_id" = "titles"."id"').rows
    rows = rows.delete_if { |r| r[1].index(name).nil? }
    find(rows.collect { |r| r[0] })
  end
end
