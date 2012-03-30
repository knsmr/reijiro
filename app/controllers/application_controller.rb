class ApplicationController < ActionController::Base
  protect_from_forgery
  if Reijiro::Application.config.respond_to?(:basic_auth)
    user, pass = Reijiro::Application.config.basic_auth
    http_basic_authenticate_with name: user, password: pass
  end
end
