# frozen_string_literal: true

class Corp::CorporateUsersController < ApplicationController
  def index
    @users = CorporateUser.order(id: :asc)
    if params[:s].present?
      name_query = '%' + params[:s] + '%'
      @users = @users.where('corporate_users.first_name LIKE ? OR ' +
                              'corporate_users.middle_name LIKE ? OR ' +
                              'corporate_users.last_name LIKE ?',
                            name_query, name_query, name_query)
    end
    @users = @users.page(params[:page])
  end
end
