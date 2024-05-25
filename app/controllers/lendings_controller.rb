# frozen_string_literal: true

class LendingsController < ApplicationController
  include Users::SessionsHelper
  before_action :now_item
  before_action :logged_in_user
  before_action :correct_user

  def new; end

  def edit; end

  def create # rubocop:disable Metrics
    @lent_history = if params[:tag]
                      LentHistory.new(user_id: @user.id, item_basic_info_id: @item.id, tag: params[:tag],
                                      lent_at: Time.current, period: params[:period])
                    else
                      LentHistory.new(user_id: @user.id, item_basic_info_id: @item.id, lent_at: Time.current,
                                      period: params[:period])
                    end
    if @lent_history.save
      flash[:success] = I18n.t('success.messages.lend')
      redirect_to root_url
    else
      render '', status: :unprocessable_entity
    end
  end

  def update; end

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

  def now_item
    @item = ItemBasicInfo.find_by(id: params[:item_id])
  end
end
