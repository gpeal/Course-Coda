class Professor < ActiveRecord::Base
  include Averages
  attr_accessible :title
  has_many :sections

  def to_s
    title
  end

  def self.find_by_name name
    professor = Professor.where('title LIKE ?', "%#{name}%").first
  end

  def self.search name
    ids = ActiveRecord::Base.connection.exec_query("SELECT id FROM professors WHERE title ILIKE '%#{name}%'").rows.flatten
    find(ids)
  end

  def average_course_rating
    count = 0
    sum = 0
    sections.each do |s|
      count += s.instruction * s.instruction_responses
      sum += s.instruction_responses
    end
  count / sum
  end
end
