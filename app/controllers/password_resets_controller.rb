class PasswordResetsController < ApplicationController
  before_action :find_user_reset_password, only: :create
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "sent_reset_pass_msg"
    redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      handle_empty_password
    elsif @user.update_attributes user_params
      handle_reseted_password
    else
      handle_invalid_password
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user_reset_password
    @user = User.find_by email: params[:password_reset][:email].downcase
    handle_invalid_user if @user.nil?
  end

  def handle_invalid_user
    flash.now[:danger] = t "email_not_found_msg"
    render :new
  end

  def load_user
    @user = User.find_by email: params[:email]
    handle_invalid_user if @user.nil?
  end

  # Confirms a valid user.
  def valid_user
    redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  # Checks expiration of reset token.
  def check_expiration
    handle_link_expired if @user.password_reset_expired?
  end

  def handle_empty_password
    @user.errors.add :password, t("cant_be_empty_msg")
    render :edit
  end

  def handle_reseted_password
    log_in @user
    flash[:success] = t "password_reseted_msg"
    redirect_to @user
  end

  def handle_invalid_password
    flash[:danger] = t "invalid_password"
    render :edit
  end

  def handle_link_expired
    flash[:danger] = t "link_expired_msg"
    redirect_to new_password_reset_url
  end
end
