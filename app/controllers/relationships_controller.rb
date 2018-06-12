class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    handle_follow_error if @user.nil?
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by id: params[:id]
    handle_follow_error if @user.nil? || @user.followed.nil?
    @user_followed = @user.followed
    current_user.unfollow @user_followed
    respond_to do |format|
      format.html{redirect_to @user_followed}
      format.js
    end
  end

  private

  def handle_follow_error
    flash[:danger] = t "action_error_msg"
    root_path
  end
end
