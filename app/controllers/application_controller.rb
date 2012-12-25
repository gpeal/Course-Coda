class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :subjects

  def subjects
    @subjects ||= Subject.all.sort_by(&:name)
  end
end
