# frozen_string_literal: true

class LendingsController < UserControllerBase
  before_action :now_item

  def new; end

  def edit
    @lent_history = LentHistory.find_by(id: params[:id])
  end

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
      flash.now[:danger] = I18n.t('success.messages.not-lend')
      render 'lendings/new', status: :unprocessable_entity
    end
  end

  def update
    @lent_history = LentHistory.find_by(id: params[:id])
    if params[:period]
      @lent_history.update(period: params[:period])
      flash[:success] = I18n.t('success.messages.extension')
      redirect_to root_url
    elsif params[:returned_at]
      @lent_history.update(returned_at: params[:returned_at])
      flash[:success] = I18n.t('success.messages.return')
      redirect_to root_url
    end
  end

  private

  def now_item
    @item = ItemBasicInfo.find_by(id: params[:item_id]) if params[:item_id]
  end
end
