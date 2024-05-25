# frozen_string_literal: true

require 'test_helper'

class ItemBasicInfoTest < ActiveSupport::TestCase
  def setup
    @info = ItemBasicInfo.new(name: 'bible', item_type: ItemType.first, count: 1)
  end

  describe 'validation' do
    describe 'name' do
      context 'when name is nil' do
        test 'fails' do
          @info.name = nil

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '物品名を入力してください', @info.errors.full_messages.first
        end
      end

      context 'when name is empty' do
        test 'fails' do
          @info.name = ''

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '物品名を入力してください', @info.errors.full_messages.first
        end
      end

      context 'when name is white spaces' do
        test 'fails' do
          @info.name = '  '

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '物品名を入力してください', @info.errors.full_messages.first
        end
      end

      context 'when name duplicates in the same item_type' do
        test 'fails' do
          ItemBasicInfo.create!(name: 'bible', item_type: ItemType.first, count: 1)

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '物品名はすでに存在します', @info.errors.full_messages.first
        end
      end

      context 'when name duplicates in different item_types' do
        test 'success' do
          ItemBasicInfo.create!(name: 'bible', item_type: ItemType.create!(name: 'other'), count: 1)

          assert @info.valid?
        end
      end

      context 'when name is valid' do
        test 'success' do
          assert @info.valid?
        end
      end
    end

    describe 'count & tags' do
      context 'when both are nil' do
        test 'fails' do
          @info.count = @info.tags = nil

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '会社所有数とタグ一覧どちらか一方を指定してください', @info.errors.full_messages.first
        end
      end

      context 'when both are not nil' do
        test 'fails' do
          @info.count = 1
          @info.tags = ['A']

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '会社所有数とタグ一覧はどちらか一方のみ指定できます', @info.errors.full_messages.first
        end
      end

      context 'when count is nil and tags is empty' do
        test 'fails' do
          @info.count = nil
          @info.tags = []

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '会社所有数とタグ一覧どちらか一方を指定してください', @info.errors.full_messages.first
        end
      end

      context 'when count is nil and tags is not empty' do
        test 'success' do
          @info.count = nil
          @info.tags = ['A']

          assert @info.valid?
        end
      end

      context 'when count is not nil and tags is nil' do
        test 'success' do
          @info.count = 1
          @info.tags = nil

          assert @info.valid?
        end
      end
    end

    describe 'count' do
      context 'when count is less than 0' do
        test 'fails' do
          @info.count = -1

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal '会社所有数は0以上の値にしてください', @info.errors.full_messages.first
        end
      end

      context 'when count is equals to 0' do
        test 'success' do
          @info.count = 0

          assert @info.valid?
        end
      end

      context 'when count is greater than 0' do
        test 'success' do
          @info.count = 1

          assert @info.valid?
        end
      end
    end

    describe 'tags' do
      context 'when tags has a blank' do
        test 'fails' do
          @info.count = nil
          @info.tags = ['']

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal 'タグ一覧に空文字は含められません', @info.errors.full_messages.first
        end
      end

      context 'when tags has a duplication' do
        test 'fails' do
          @info.count = nil
          @info.tags = %w[aa aa]

          assert_not @info.valid?
          assert_equal 1, @info.errors.full_messages.length
          assert_equal 'タグ一覧は一意である必要があります', @info.errors.full_messages.first
        end
      end

      context 'when tags has compatible values' do
        test 'success' do
          @info.count = nil
          @info.tags = %w[a b c]

          assert @info.valid?
        end
      end
    end
  end

  describe '.convert_max_lent_period' do
    test 'returns converted duration' do
      result = ItemBasicInfo.convert_max_lent_period('1/2/3')

      assert ActiveSupport::Duration.parse('P1Y2M3D'), result
    end
  end

  describe '#has_count?' do
    context 'when count is nil' do
      test 'returns false' do
        @info.count = nil

        assert_not @info.has_count?
      end
    end

    context 'when count is not nil' do
      test 'returns true' do
        @info.count = 1

        assert @info.has_count?
      end
    end
  end

  describe '#has_tags?' do
    context 'when tags is nil' do
      test 'returns false' do
        @info.tags = nil

        assert_not @info.has_tags?
      end
    end

    context 'when tags is not nil' do
      test 'returns true' do
        @info.tags = %w[a]

        assert @info.has_tags?
      end
    end
  end

  describe '#max_lent_period_as_string' do
    context 'whem max_lent_period is nil' do
      test 'returns nil' do
        @info.max_lent_period = nil

        assert_nil @info.max_lent_period_as_string
      end
    end

    context 'when max_lent_period is not nil' do
      test 'returns string' do
        @info.max_lent_period = ActiveSupport::Duration.parse('P1Y2M3D')

        assert_equal '1/2/3', @info.max_lent_period_as_string
      end
    end
  end
end
