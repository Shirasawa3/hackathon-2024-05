# frozen_string_literal: true

class UsersController < UserControllerBase
  def show
    @lent_histories = @user.lent_histories.order(returned_at: :desc)
    @lent_histories = @lent_histories.in_lent if params[:lent_status].present? && params[:lent_status].to_i == 1
    @lent_histories = @lent_histories.not_in_lent if params[:lent_status].present? && params[:lent_status].to_i == 2
    @lent_histories = @lent_histories.page(params[:page])
  end
end
