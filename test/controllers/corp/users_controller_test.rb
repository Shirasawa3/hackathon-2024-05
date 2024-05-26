# frozen_string_literal: true

require 'test_helper'

class Corp::UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    corp_user = CorporateUser.create!(id: 1,
                                      first_name: '太郎',
                                      last_name: '田中',
                                      employee_id: 'A101',
                                      email: 'taro.tanaka@techouse.jp',
                                      password: 'password')
    login_as(corp_user)
    @user = User.create!(id: 1,
                         first_name: '太郎',
                         last_name: '田中',
                         employee_id: 'A101',
                         department: '開発',
                         email: 'taro.tanaka@techouse.jp')
  end

  describe '#index' do
    context 'as a guest' do
      test 'returns 302 response' do
        logout
        get corp_users_path

        assert_response :found
      end

      test 'redirects to sign in page' do
        logout
        get corp_users_path

        assert_redirected_to new_corporate_user_session_path
      end
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
      test 'returns 302 response' do
        logout
        get corp_user_path(1)

        assert_response :found
      end

      test 'redirects to sign in page' do
        logout
        get corp_user_path(1)

        assert_redirected_to new_corporate_user_session_path
      end
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
