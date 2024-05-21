# frozen_string_literal: true

require 'test_helper'

class ItemTypeTest < ActiveSupport::TestCase
  describe 'validation' do
    describe 'name' do
      context 'when name is nil' do
        test 'fails' do
          item_type = ItemType.new(name: nil)

          assert_not item_type.valid?
          assert_equal 1, item_type.errors.full_messages.length
          assert_equal '種別名を入力してください', item_type.errors.full_messages.first
        end
      end

      context 'when name is empty' do
        test 'fails' do
          item_type = ItemType.new(name: '')

          assert_not item_type.valid?
          assert_equal 1, item_type.errors.full_messages.length
          assert_equal '種別名を入力してください', item_type.errors.full_messages.first
        end
      end

      context 'when name is white spaces' do
        test 'fails' do
          item_type = ItemType.new(name: '  ')

          assert_not item_type.valid?
          assert_equal 1, item_type.errors.full_messages.length
          assert_equal '種別名を入力してください', item_type.errors.full_messages.first
        end
      end

      context 'when name is duplicated' do
        test 'fails' do
          ItemType.create!(name: '物品X')
          item_type = ItemType.new(name: '物品X')

          assert_not item_type.valid?
          assert_equal 1, item_type.errors.full_messages.length
          assert_equal '種別名はすでに存在します', item_type.errors.full_messages.first
        end
      end

      context 'when name is valid' do
        test 'success' do
          item_type = ItemType.new(name: '物品X')

          assert item_type.valid?
        end
      end
    end
  end
end
