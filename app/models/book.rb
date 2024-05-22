# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :item_basic_info
end
