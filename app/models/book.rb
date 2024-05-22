# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :item_basic_info, autosave: true, dependent: :destroy

  delegate :name, :max_lent_period, :item_type_id, :item_type, :count, :tags, :status, :is_extendable,
           to: :item_basic_info

  after_initialize do
    build_item_basic_info unless item_basic_info
  end
end
