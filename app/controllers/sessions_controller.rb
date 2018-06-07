class SessionsController < ApplicationController
  before_action :find_user_by_email, only: :create

  def new; end

  def create
    if @user.authenticate params[:session][:password]
      login_checkremember
    else
      handle_invalid_user
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
    handle_invalid_user if @user.nil?
  end

  def login_checkremember
    log_in @user
    params[:session][:remember_me] == Settings.true_value ? remember(@user) : forget(@user)
    redirect_to @user
  end

  def handle_invalid_user
    flash[:danger] = Settings.invalid_banner
    render :new
  end
end
