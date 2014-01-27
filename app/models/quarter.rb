class Quarter < ActiveRecord::Base
  include Comparable
  # attr_accessible :title

  def to_s
    title
  end

  def <=>(other)
    quarter_hash = {
      :winter => 0,
      :spring => 1,
      :summer => 2,
      :fall => 3
    }

    return quarter_hash[self.title.downcase.to_sym] <=> quarter_hash[other.title.downcase.to_sym]
  end
end
