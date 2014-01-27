class Year < ActiveRecord::Base
  include Comparable
  # attr_accessible :title

  def to_i
    title
  end

  def to_s
    title.to_s
  end

  def <=>(other)
    return self.title.to_i <=> other.title.to_i
  end
end
