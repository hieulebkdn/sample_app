class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      user.update_attributes(activated: true, activated_at: Time.zone.now)
      handle_edit
    else
      flash[:danger] = t "invalid_link"
      redirect_to root_url
    end
  end

  def handle_edit
    log_in user
    flash[:success] = t "acc_activated"
    redirect_to user
  end
end
