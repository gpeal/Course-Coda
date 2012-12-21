class Feedback < ActiveRecord::Base
  attr_accessible :feedback, :section_id, :sentiment
  validates :feedback, :presence => true

  belongs_to :section

  def as_json(options={})
    if options.member?(:only) or options.member?(:except) or options.member?(:include)
      return super(options)
    else
      return super(:only => [:id, :feedback])
    end
  end
end
