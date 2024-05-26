# frozen_string_literal: true

require 'csv'

class Corp::UploadUsersCsvUseCase
  Result = Data.define(:success_count, :skip_count)

  # @param csv_io [IO] CSV を表す IO オブジェクト
  # @param overwrite [true, false] 既存のレコードを上書きするかどうか
  # @return [Result]
  def execute(csv_io, overwrite)
    csv = CSV.new(csv_io, headers: true, liberal_parsing: true)
    success_count = 0
    skip_count = 0

    ItemBasicInfo.transaction do
      csv.each do |row|
        employee_id = row['社員番号']
        info = User.find_by(employee_id:)
        attributes = {
          first_name: row['名'],
          last_name: row['姓'],
          department: row['所属'],
          email: row['Email'],
        }
        if info
          if overwrite
            info.update!(attributes)
            success_count += 1
          else
            skip_count += 1
          end
        else
          attributes['employee_id'] = employee_id
          User.create!(attributes)
          success_count += 1
        end
      end
    end

    Result.new(success_count, skip_count)
  end
end
