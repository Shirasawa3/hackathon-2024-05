# frozen_string_literal: true

require 'minitest/autorun'

class Corp::UploadItemsCsvUseCaseTest < ActiveSupport::TestCase
  def setup
    (1..5).each do |i|
      Book.create!(item_basic_info: ItemBasicInfo.new(item_type_id: 1, name: "書籍#{i}", count: i))
    end
    Headset.create!(item_basic_info: ItemBasicInfo.new(item_type_id: 2,
                                                       name: 'ヘッドセット型番A',
                                                       tags: (1..30).map { |i| "TEC-A#{format('%03d', i)}" }))
  end

  describe '#execute' do
    context 'error occurres' do
      test 'does not create nor update any records' do
        csv_io = StringIO.new <<~CSV
          type,name,count,tags,max_lent_period,is_extendable,status
          書籍,ドグラ・マグラ,10,,0/1/0,false,available
          ヘッドセット,,,TEC-T001;TEC-T002;TEC-T003,,true,available
          書籍,禁書,1,,1/0/0,false,hidden
          書籍,書籍1,3,,0/0/1,false,available
        CSV
        assert_raises { Corp::UploadItemsCsvUseCase.new.execute(csv_io, true) }

        assert_equal 5, Book.count
        assert_equal 1, Headset.count

        noupdated_book_info = ItemBasicInfo.find_by(name: '書籍1')
        assert_equal 1, noupdated_book_info.count
        assert_nil noupdated_book_info.tags
        assert_nil noupdated_book_info.max_lent_period
        assert_equal true, noupdated_book_info.is_extendable
        assert_equal 'available', noupdated_book_info.status
      end
    end
    context 'normal case' do
      test 'create new records' do
        csv_io = StringIO.new <<~CSV
          type,name,count,tags,max_lent_period,is_extendable,status
          書籍,ドグラ・マグラ,10,,0/1/0,false,available
          ヘッドセット,型番T,,TEC-T001;TEC-T002;TEC-T003,,true,available
          書籍,禁書,1,,1/0/0,false,hidden
        CSV
        result = Corp::UploadItemsCsvUseCase.new.execute(csv_io, false)

        assert_equal 3, result.success_count
        assert_equal 0, result.skip_count

        assert_equal 7, Book.count
        assert_equal 2, Headset.count
      end

      context 'when overwrite is true' do
        test 'updates existing records' do
          csv_io = StringIO.new <<~CSV
            type,name,count,tags,max_lent_period,is_extendable,status
            書籍,書籍1,3,,0/0/1,false,available
          CSV
          result = Corp::UploadItemsCsvUseCase.new.execute(csv_io, true)

          assert_equal 1, result.success_count
          assert_equal 0, result.skip_count

          updated_book_info = ItemBasicInfo.find_by(name: '書籍1')
          assert_equal 3, updated_book_info.count
          assert_nil updated_book_info.tags
          assert_equal 1.day, updated_book_info.max_lent_period
          assert_equal false, updated_book_info.is_extendable
          assert_equal 'available', updated_book_info.status
        end
      end

      context 'when overwrite is false' do
        test 'does not update any existing records' do
          csv_io = StringIO.new <<~CSV
            type,name,count,tags,max_lent_period,is_extendable,status
            書籍,書籍1,3,,0/0/1,false,available
          CSV
          result = Corp::UploadItemsCsvUseCase.new.execute(csv_io, false)

          assert_equal 0, result.success_count
          assert_equal 1, result.skip_count

          noupdated_book_info = ItemBasicInfo.find_by(name: '書籍1')
          assert_equal 1, noupdated_book_info.count
          assert_nil noupdated_book_info.tags
          assert_nil noupdated_book_info.max_lent_period
          assert_equal true, noupdated_book_info.is_extendable
          assert_equal 'available', noupdated_book_info.status
        end
      end
    end
  end
end
