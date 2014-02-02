class TestMailer < ActionMailer::Base
  def test_mail()
    mail(:to => "gabriel@gpeal.com", :subject => "Registered", :from => "gabe@nuctecs.com")
  end
end
