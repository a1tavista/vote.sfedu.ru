class DebugController < ApplicationController
  def login_as
    sign_in(User.find_by_email(params[:email])) if ENV["DEBUG_LOGIN_INTO_ACCOUNT"]
  end
end
