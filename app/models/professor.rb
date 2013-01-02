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
    keys = REDIS.keys("PROFESSOR *#{name.split(' ').join('*')}*")
    ids = keys.collect {|key| key[-5..-1].to_i}
    find(ids)
  end
end
