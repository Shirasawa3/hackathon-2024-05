# frozen_string_literal: true

class ItemType < ApplicationRecord
  has_one :item_basic_info, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
