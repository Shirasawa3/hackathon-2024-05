# frozen_string_literal: true

class Corp::ItemsController < ApplicationController
  def index
    @items = ItemBasicInfo.eager_load(:item_type, :lent_histories)
                          .order(created_at: :asc)
    @items = @items.where('item_basic_infos.name LIKE ?', '%' + params[:s] + '%') if params[:s].present?
    @items = @items.where(item_type_id: params[:type].to_i) if params[:type].present? && params[:type].to_i.positive?
    @items = @items.page(params[:page])
  end

  def show
    @item = ItemBasicInfo.find_by(id: params[:id])

    unless @item
      flash[:danger] = I18n.t('flash.corp.items.not_found', id: params[:id])
      redirect_to corp_items_path
    end
  end

  def new
    @item = ItemBasicInfo.new(count: 0)
  end

  def edit
    @item = ItemBasicInfo.find_by(id: params[:id])

    unless @item
      flash[:danger] = I18n.t('flash.corp.items.not_found', id: params[:id])
      redirect_to corp_items_path
    end
  end

  def create
    @item = ItemBasicInfo.new(item_params)
    unless @item.save
      render 'new', status: :unprocessable_entity
      return
    end

    redirect_to corp_items_path
  end

  def update
    @item = ItemBasicInfo.find(params[:id])
    @item.count = @item.tags = nil
    @item.assign_attributes(item_params)
    unless @item.save
      render 'edit', status: :unprocessable_entity
      return
    end

    redirect_to corp_items_path(@item.id)
  end

  private

  # Strong Parameter を生成する
  # @return [ActionController::Parameters]
  def item_params
    result = params.require(:item)
                   .permit(:name, :item_type_id, :status, :count_type, :count, :tags, :max_lent_period, :is_extendable)
    result.delete(:count_type)
    result[:status] = result[:status].to_i
    result[:tags] = result[:tags].split("\n").filter(&:present?) if result[:tags]
    if result[:max_lent_period]
      result[:max_lent_period] = ItemBasicInfo.convert_max_lent_period(result[:max_lent_period])
    end
    result
  end
end
