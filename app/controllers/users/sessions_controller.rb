class Users::SessionsController < Devise::SessionsController
  skip_before_filter :landing_redirect

end