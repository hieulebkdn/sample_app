class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

  private

  # Confirms a logged-in user.
  def logged_in_user
    warn_logged_in unless logged_in?
  end

  def warn_logged_in
    store_location
    flash[:danger] = t "login_banner"
    redirect_to login_url
  end
end
