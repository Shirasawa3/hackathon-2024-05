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
    @item = ItemBasicInfo.find(params[:id])
  end

  def new; end

  def edit; end

  def create; end

  def update; end
end
