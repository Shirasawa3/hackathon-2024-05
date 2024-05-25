# frozen_string_literal: true

class UsersController < ApplicationController
  include Users::SessionsHelper
  before_action :logged_in_user
  before_action :correct_user

  def show
    @lent_histories = @user.lent_histories.order(created_at: :asc)
    @lent_histories = @lent_histories.in_lent if params[:type].present? && params[:type].to_i == 1
    @lent_histories = @lent_histories.not_in_lent if params[:type].present? && params[:type].to_i == 2
    @lent_histories = @lent_histories.page(params[:page])
  end

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if user_logged_in?

    flash[:danger] = 'Please log in.' # rubocop: disable Rails
    redirect_to users_sign_in_url, status: :see_other
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(session[:user_id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
  end
end
