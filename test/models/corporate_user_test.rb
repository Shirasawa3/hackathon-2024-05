# frozen_string_literal: true

require 'test_helper'

class CorporateUserTest < ActiveSupport::TestCase
  def setup
    @user = CorporateUser.new(last_name: '田中',
                              first_name: '太郎',
                              employee_id: 'A101',
                              email: 'taro.tanaka@techouse.jp',
                              password: 'password')
  end

  describe 'validation' do
    describe 'first_name' do
      context 'when first_name is nil' do
        test 'fails' do
          @user.first_name = nil

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '名を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when first_name is empty' do
        test 'fails' do
          @user.first_name = ''

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '名を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when first_name is white spaces' do
        test 'fails' do
          @user.first_name = '  '

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '名を入力してください', @user.errors.full_messages.first
        end

        context 'when first_name is valid' do
          test 'success' do
            @user.first_name = '太郎'

            assert @user.valid?
          end
        end
      end
    end

    describe 'middle_name' do
      context 'when middle_name is nil' do
        test 'success' do
          @user.middle_name = nil

          assert @user.valid?
        end
      end

      context 'when middle_name is empty' do
        test 'fails' do
          @user.middle_name = ''

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal 'ミドルネームを入力してください', @user.errors.full_messages.first
        end
      end

      context 'when middle_name is white spaces' do
        test 'fails' do
          @user.middle_name = '  '

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal 'ミドルネームを入力してください', @user.errors.full_messages.first
        end

        context 'when middle_name is valid' do
          test 'success' do
            @user.middle_name = 'ミドル'

            assert @user.valid?
          end
        end
      end
    end

    describe 'last_name' do
      context 'when last_name is nil' do
        test 'fails' do
          @user.last_name = nil

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '姓を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when last_name is empty' do
        test 'fails' do
          @user.last_name = ''

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '姓を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when last_name is white spaces' do
        test 'fails' do
          @user.last_name = '  '

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '姓を入力してください', @user.errors.full_messages.first
        end

        context 'when last_name is valid' do
          test 'success' do
            @user.last_name = '田中'

            assert @user.valid?
          end
        end
      end
    end

    describe 'employee_id' do
      context 'when employee_id is nil' do
        test 'fails' do
          @user.employee_id = nil

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '社員番号を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when employee_id is empty' do
        test 'fails' do
          @user.employee_id = ''

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '社員番号を入力してください', @user.errors.full_messages.first
        end
      end

      context 'when employee_id is white spaces' do
        test 'fails' do
          @user.employee_id = '  '

          assert_not @user.valid?
          assert_equal 1, @user.errors.full_messages.length
          assert_equal '社員番号を入力してください', @user.errors.full_messages.first
        end

        context 'when employee_id is duplicated' do
          test 'fails' do
            CorporateUser.create!(first_name: 'duplicated',
                                  last_name: 'duplicated',
                                  employee_id: 'A101',
                                  email: 'hogehoge@techouse.jp',
                                  password: 'password')

            assert_not @user.valid?
            assert_equal 1, @user.errors.full_messages.length
            assert_equal '社員番号はすでに存在します', @user.errors.full_messages.first
          end
        end

        context 'when employee_id is valid' do
          test 'success' do
            @user.employee_id = 'A111'

            assert @user.valid?
          end
        end
      end
    end

    describe 'email' do
      context 'when email is nil' do
        test 'fails' do
          @user.email = nil

          assert_not @user.valid?
          assert @user.errors.full_messages.include? 'メールアドレスを入力してください'
        end
      end

      context 'when email is empty' do
        test 'fails' do
          @user.email = ''

          assert_not @user.valid?
          assert @user.errors.full_messages.include? 'メールアドレスを入力してください'
        end
      end

      context 'when email is white spaces' do
        test 'fails' do
          @user.email = '  '

          assert_not @user.valid?
          assert @user.errors.full_messages.include? 'メールアドレスを入力してください'
        end

        context 'when email is duplicated' do
          test 'fails' do
            CorporateUser.create!(first_name: 'duplicated',
                                  last_name: 'duplicated',
                                  employee_id: 'A102',
                                  email: 'taro.tanaka@techouse.jp',
                                  password: 'password')

            assert_not @user.valid?
            assert_equal 1, @user.errors.full_messages.length
            assert_equal 'メールアドレスはすでに存在します', @user.errors.full_messages.first
          end
        end

        context 'when format of email is invalid' do
          test 'fails' do
            @user.email = 'invalid'

            assert_not @user.valid?
            assert_equal 1, @user.errors.full_messages.length
            assert_equal 'メールアドレスは不正な値です', @user.errors.full_messages.first
          end
        end

        context 'when email is valid' do
          test 'success' do
            @user.email = 'tanaka.taro@techouse.jo'

            assert @user.valid?
          end
        end
      end
    end
  end

  describe '#full_name' do
    context 'when middle_name is nil' do
      test 'returns as "last_name first_name"' do
        @user.middle_name = nil

        assert_equal '田中 太郎', @user.full_name
      end
    end

    context 'when middle_name is not nil' do
      test 'returns as "last_name middle_name first_name"' do
        @user.middle_name = 'ミドル'

        assert_equal '田中 ミドル 太郎', @user.full_name
      end
    end
  end
end
