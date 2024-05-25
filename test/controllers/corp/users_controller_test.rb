# frozen_string_literal: true

require 'test_helper'

class Corp::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(id: 1,
                         first_name: '太郎',
                         last_name: '田中',
                         employee_id: 'A101',
                         department: '開発',
                         email: 'taro.tanaka@techouse.jp')
  end

  describe '#index' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      test 'returns a 200 response' do
        get corp_users_path
        assert_response :ok
      end
    end
  end

  describe '#show' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      context 'when item exists' do
        test 'returns a 200 response' do
          get corp_user_path(1)

          assert_response :ok
        end
      end

      context 'when item does not exist' do
        test 'returns a 302 response' do
          @user.destroy
          get corp_user_path(1)

          assert_response :found
        end

        test 'redirects to #index' do
          @user.destroy
          get corp_user_path(1)

          assert_redirected_to corp_users_path
        end
      end
    end
  end
end
