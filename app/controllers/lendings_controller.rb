# frozen_string_literal: true

class LendingsController < UserControllerBase
  before_action :now_item

  def new; end

  def edit; end

  def create
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

  def now_item
    @item = ItemBasicInfo.find_by(id: params[:item_id])
  end
end
