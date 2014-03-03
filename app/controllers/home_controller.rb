class HomeController < ApplicationController
  respond_to :html
  skip_before_filter :landing_redirect, only: [:welcome, :sign]

  def index
  end

  def welcome
    render layout: false
  end

  def sign
    Signature.create(signature_params)
    render status: 200, json: @controller.to_json
  end

private
  def signature_params
    params.permit(:email, :university)
  end

end
