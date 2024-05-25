# frozen_string_literal: true

class ItemsController < ApplicationController
  include Users::SessionsHelper
  before_action :logged_in_user
  before_action :correct_user

  def index
    @items = ItemBasicInfo.eager_load(:item_type, :lent_histories)
                          .order(created_at: :asc)
    @items = @items.where('item_basic_infos.name LIKE ?', '%' + params[:s] + '%') if params[:s].present?
    @items = @items.where(item_type_id: params[:type].to_i) if params[:type].present? && params[:type].to_i.positive?
    @items = @items.page(params[:page])
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
