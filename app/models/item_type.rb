# frozen_string_literal: true

class ItemType < ApplicationRecord
  has_many :item_basic_infos, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
