class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :landing_redirect

end