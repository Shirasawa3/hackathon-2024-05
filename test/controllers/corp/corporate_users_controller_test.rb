# frozen_string_literal: true

require 'test_helper'

class Corp::CorporateUsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    user = CorporateUser.create!(id: 1,
                                 first_name: '太郎',
                                 last_name: '田中',
                                 employee_id: 'A101',
                                 email: 'taro.tanaka@techouse.jp',
                                 password: 'password')
    login_as(user)
  end

  describe '#index' do
    context 'as a guest' do
      test 'returns 302 response' do
        logout
        get corp_corporate_users_path

        assert_response :found
      end

      test 'redirects to sign in page' do
        logout
        get corp_corporate_users_path

        assert_redirected_to new_corporate_user_session_path
      end
    end

    context 'as a user' do
      test 'returns a 200 response' do
        get corp_corporate_users_path
        assert_response :ok
      end
    end
  end
end
