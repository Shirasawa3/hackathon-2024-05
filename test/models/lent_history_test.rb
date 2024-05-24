# frozen_string_literal: true

require 'test_helper'

class LentHistoryTest < ActiveSupport::TestCase
  def setup
    user = User.create!(first_name: 'Taro',
                        last_name: 'Tanaka',
                        employee_id: 'A101',
                        department: '本部',
                        email: 'taro.tanaka@techouse.jp')
    item = ItemBasicInfo.create!(name: 'bible', item_type: ItemType.first, count: 1)

    @history = LentHistory.new(user:, item_basic_info: item, lent_at: Time.current, period: 1.day.from_now)

    freeze_time
  end

  def teardown
    unfreeze_time
  end

  describe 'validation' do
    describe 'tag' do
      context 'when tag is nil' do
        test 'success' do
          @history.tag = nil
          assert @history.valid?
        end
      end

      context 'when tag is empty' do
        test 'fails' do
          @history.tag = ''

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal 'タグ名を入力してください', @history.errors.full_messages.first
        end
      end

      context 'when tag is white spaces' do
        test 'fails' do
          @history.tag = '  '

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal 'タグ名を入力してください', @history.errors.full_messages.first
        end
      end

      context 'when tag is valid' do
        test 'success' do
          @history.tag = 'TEC-0001'

          assert @history.valid?
        end
      end
    end

    describe 'lent_at' do
      context 'when lent_at is nil' do
        test 'fails' do
          @history.lent_at = nil

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '貸出開始日時を入力してください', @history.errors.full_messages.first
        end
      end

      context 'when lent_at is valid' do
        test 'success' do
          @history.lent_at = Time.current

          assert @history.valid?
        end
      end
    end

    describe 'period' do
      context 'when period is nil' do
        test 'fails' do
          @history.period = nil

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '返却期限を入力してください', @history.errors.full_messages.first
        end
      end

      context 'when period represents a past of lent_at' do
        test 'fails' do
          @history.period = 1.day.ago

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '返却期限は貸出開始日時より後に設定してください', @history.errors.full_messages.first
        end
      end

      context 'when period equals to lent_at' do
        test 'fails' do
          @history.period = Time.current

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '返却期限は貸出開始日時より後に設定してください', @history.errors.full_messages.first
        end
      end

      context 'when period is valid' do
        test 'success' do
          @history.period = 1.day.from_now

          assert @history.valid?
        end
      end
    end

    describe 'returned_at' do
      context 'when returned_at is nil' do
        test 'success' do
          @history.returned_at = nil

          assert @history.valid?
        end
      end

      context 'when returned_at represents a past of lent_at' do
        test 'fails' do
          @history.returned_at = 1.day.ago

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '返却期限は貸出開始日時より後に設定してください', @history.errors.full_messages.first
        end
      end

      context 'when returned_at equals to lent_at' do
        test 'fails' do
          @history.returned_at = Time.current

          assert_not @history.valid?
          assert_equal 1, @history.errors.full_messages.length
          assert_equal '返却期限は貸出開始日時より後に設定してください', @history.errors.full_messages.first
        end
      end

      context 'when returned_at is valid' do
        test 'success' do
          assert @history.returned_at = 1.day.from_now

          assert @history.valid?
        end
      end
    end
  end

  describe '#in_lent' do
    test 'returns records as not returned' do
      @history.save!
      LentHistory.create!(user: User.first!,
                          item_basic_info: ItemBasicInfo.first!,
                          lent_at: 3.days.ago,
                          period: Time.current,
                          returned_at: 1.day.ago)

      assert_equal [@history], LentHistory.in_lent.to_a
    end
  end

  describe '#not_in_lent' do
    test 'returns records as returned' do
      @history.save!
      returned = LentHistory.create!(user: User.first!,
                                     item_basic_info: ItemBasicInfo.first!,
                                     lent_at: 3.days.ago,
                                     period: Time.current,
                                     returned_at: 1.day.ago)

      assert_equal [returned], LentHistory.not_in_lent.to_a
    end
  end
end
