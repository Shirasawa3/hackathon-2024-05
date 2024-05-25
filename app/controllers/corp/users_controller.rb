# frozen_string_literal: true

class Corp::UsersController < ApplicationController
  def index
    @users = User.order(id: :asc)
    if params[:s].present?
      name_query = '%' + params[:s] + '%'
      @users = @users.where('users.first_name LIKE ? OR users.middle_name LIKE ? OR users.last_name LIKE ?',
                            name_query, name_query, name_query)
    end
    @users = @users.page(params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:danger] = I18n.t('flash.corp.users.not_found', id: params[:id])
      redirect_to corp_users_path
    end
  end
end
