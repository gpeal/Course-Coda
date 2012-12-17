class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exceptions::TooManySections do |exception|
    redirect_to root_url, :alert => 'Search returned too many sections. Try narrowing your search terms.'
  end
end
