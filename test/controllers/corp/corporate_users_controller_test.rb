# frozen_string_literal: true

require 'test_helper'

class Corp::CorporateUsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = CorporateUser.create!(id: 1,
                                  first_name: '太郎',
                                  last_name: '田中',
                                  employee_id: 'A101',
                                  email: 'taro.tanaka@techouse.jp',
                                  password: 'password')
  end

  describe '#index' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      test 'returns a 200 response' do
        get corp_corporate_users_path
        assert_response :ok
      end
    end
  end
end
