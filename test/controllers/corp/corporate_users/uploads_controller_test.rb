# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class Corp::CorporateUsers::UploadsControllerTest < ActionDispatch::IntegrationTest
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

  describe '#new' do
    context 'as a guest' do
      test 'returns 302 response' do
        logout
        get new_corp_corporate_users_upload_path

        assert_response :found
      end

      test 'redirects to sign in page' do
        logout
        get new_corp_corporate_users_upload_path

        assert_redirected_to new_corporate_user_session_path
      end
    end

    context 'as a user' do
      test 'returns 200 response' do
        get new_corp_corporate_users_upload_path
        assert_response :ok
      end
    end
  end

  describe '#create' do
    context 'as a guest' do
      test 'returns 302 response' do
        logout
        post corp_corporate_users_uploads_path

        assert_response :found
      end

      test 'redirects to sign in page' do
        logout
        post corp_corporate_users_uploads_path

        assert_redirected_to new_corporate_user_session_path
      end
    end

    context 'as a user' do
      context 'when file type is invalid' do
        test 'returns 302 response' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/plain'),
              },
            }
          end

          assert_response :found
        end

        test 'redirects to #new' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/plain'),
              },
            }
          end

          assert_redirected_to new_corp_corporate_users_upload_path
        end

        test 'sets flash message' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/plain'),
              },
            }
          end

          assert_equal 'CSV以外のファイルはアップロードできません', flash[:danger]
        end
      end

      context 'normal case' do
        test 'returns 302 response' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/csv'),
              },
            }
          end

          assert_response :found
        end

        test 'redirects to #new' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/csv'),
              },
            }
          end

          assert_redirected_to new_corp_corporate_users_upload_path
        end

        test 'sets flash message' do
          mock_use_case = Minitest::Mock.new
          mock_use_case.expect(:execute, Corp::UploadCorporateUsersCsvUseCase::Result.new(3, 1), [IO, true])

          Corp::UploadCorporateUsersCsvUseCase.stub :new, mock_use_case do
            post corp_corporate_users_uploads_path, params: {
              upload: {
                overwrite: '1',
                csv: fixture_file_upload('csvs/users/test.csv', 'text/csv'),
              },
            }
          end

          assert_equal '3件のユーザー情報を作成・更新しました（1件のスキップ）', flash[:success]
        end
      end
    end
  end
end
