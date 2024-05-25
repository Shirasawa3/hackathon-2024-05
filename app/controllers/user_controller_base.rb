# frozen_string_literal: true

class UserControllerBase < ApplicationController
  include Users::SessionsHelper
  before_action :logged_in_user
  before_action :redirect_if_invalid_user

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    flash[:danger] = 'Please log in.' # rubocop: disable Rails
    redirect_to users_sign_in_url, status: :see_other
  end

  # 正しいユーザーかどうか確認
  def redirect_if_invalid_user
    @user = User.find(session[:user_id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
  end
end
