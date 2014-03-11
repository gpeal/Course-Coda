class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts={})
      mail = super
      mail.subject = "Registration Confirmation for Course Coda"
      mail
    end

end