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

  def self.find_by_name name
    professor = Professor.where('title LIKE ?', "%#{name}%").first
  end

  def self.search name
    @professors_hash ||= {}
    if @names_l.nil?
      @names_l = []
     Professor.all.each do |p|
        @professors_hash[p.to_s.downcase] ||= p
        @names_l << p.to_s.downcase
      end
    end

    professors = []
    name.downcase!
    @names_l.grep(/#{name.downcase}/).each do |name|
      professors << @professors_hash[name]
    end
    return professors
  end
end
