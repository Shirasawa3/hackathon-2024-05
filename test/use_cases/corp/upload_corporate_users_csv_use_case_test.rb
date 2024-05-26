# frozen_string_literal: true

require 'minitest/autorun'

class Corp::UploadCorporateUsersCsvUseCaseTest < ActiveSupport::TestCase
  def setup
    CorporateUser.create!(last_name: '田中',
                          first_name: '太郎',
                          employee_id: 'A101',
                          email: 'taro.tanaka@techouse.jp',
                          password: 'password')
  end

  describe '#execute' do
    context 'when error occurres' do
      test 'does not create nor update any records' do
        csv_io = StringIO.new <<~CSV
          社員番号,姓,名,Email,所属
          A101,,,taro@techouse.jp,本部
          100,佐藤,二郎,sato@techouse.jp,コーポレート
        CSV
        assert_raises { Corp::UploadCorporateUsersCsvUseCase.new.execute(csv_io, true) }

        assert_equal 1, CorporateUser.count

        noupdated_user = CorporateUser.find_by(employee_id: 'A101')
        assert_equal '田中', noupdated_user.last_name
        assert_equal '太郎', noupdated_user.first_name
        assert_equal 'taro.tanaka@techouse.jp', noupdated_user.email
      end
    end

    context 'normal case' do
      test 'create new records' do
        csv_io = StringIO.new <<~CSV
          社員番号,姓,名,Email,所属
          100,佐藤,二郎,sato@techouse.jp,コーポレート
          101,鈴木,三郎,suzuki@techouse.jp,コーポレート
        CSV
        result = Corp::UploadCorporateUsersCsvUseCase.new.execute(csv_io, false)

        assert_equal 2, result.success_count
        assert_equal 0, result.skip_count

        assert_equal 3, CorporateUser.count
      end

      context 'when overwrite is true' do
        test 'updates existing records' do
          csv_io = StringIO.new <<~CSV
            社員番号,姓,名,Email,所属
            A101,中田,花子,nakata@techouse.jp,本部
          CSV
          result = Corp::UploadCorporateUsersCsvUseCase.new.execute(csv_io, true)

          assert_equal 1, result.success_count
          assert_equal 0, result.skip_count

          updated_user = CorporateUser.find_by(employee_id: 'A101')
          assert_equal '中田', updated_user.last_name
          assert_equal '花子', updated_user.first_name
          assert_equal 'nakata@techouse.jp', updated_user.email
        end
      end

      context 'when overwrite is false' do
        test 'does not update any existing records' do
          csv_io = StringIO.new <<~CSV
            社員番号,姓,名,Email,所属
            A101,中田,花子,nakata@techouse.jp,本部
          CSV
          result = Corp::UploadCorporateUsersCsvUseCase.new.execute(csv_io, false)

          assert_equal 0, result.success_count
          assert_equal 1, result.skip_count

          noupdated_user = CorporateUser.find_by(employee_id: 'A101')
          assert_equal '田中', noupdated_user.last_name
          assert_equal '太郎', noupdated_user.first_name
          assert_equal 'taro.tanaka@techouse.jp', noupdated_user.email
        end
      end
    end
  end
end
