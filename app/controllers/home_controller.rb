class HomeController < ApplicationController
  respond_to :html

  def index
    puts ActionMailer::Base.smtp_settings
  end

end
