class Feedback < ActiveRecord::Base
  attr_accessible :feedback, :section_id, :sentiment
  validates :feedback, :presence => true

  belongs_to :section

end
