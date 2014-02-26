class HomeController < ApplicationController
  respond_to :html
  skip_before_filter :landing_redirect, only: [:welcome]

  def index
  end

  def welcome
    render layout: false
  end

end
