# frozen_string_literal: true

require 'csv'

class Corp::UploadItemsCsvUseCase
  Result = Data.define(:success_count, :skip_count)

  # @param csv_io [IO] CSV を表す IO オブジェクト
  # @param overwrite [true, false] 既存のレコードを上書きするかどうか
  # @return [Result]
  def execute(csv_io, overwrite)
    csv = CSV.new(csv_io, headers: true, liberal_parsing: true)
    types = ItemType.pluck(:name, :id).to_h
    success_count = 0
    skip_count = 0

    ItemBasicInfo.transaction do
      csv.each do |row|
        name = row['name']
        info = ItemBasicInfo.find_by(name:)
        attributes = {
          item_type_id: types[row['type']],
          count: row['count'].presence,
          tags: row['tags'].presence&.split(';'),
          max_lent_period: ItemBasicInfo.convert_max_lent_period(row['max_lent_period'].presence),
          is_extendable: row['is_extendable'],
          status: row['status'],
        }
        if info
          if overwrite
            info.update!(attributes)
            success_count += 1
          else
            skip_count += 1
          end
        else
          attributes['name'] = name

          info = ItemBasicInfo.create!(attributes)
          # TODO: もっと綺麗にする
          case attributes[:item_type_id]
          when 1
            Book.create!(item_basic_info: info)
          when 2
            Headset.create!(item_basic_info: info)
          else
            raise '無効な種別です'
          end
          success_count += 1
        end
      end
    end

    Result.new(success_count, skip_count)
  end
end
