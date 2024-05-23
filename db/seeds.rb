# frozen_string_literal: true

(1..5).each do |i|
  User.create!(id: i,first_name: "太郎#{i}号", last_name: '開発', employee_id: "D#{i}", email: "dev-#{i}@techouse.jp", department: '本部')
end

CorporateUser.create!(id: 1, first_name: '玲人', last_name: '工保', employee_id: 'C1', email: 'corporate@techouse.jp', password: 'password')

Book.create!(id: 1, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(1), name: '書籍1', count: 3))
Book.create!(id: 2, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(1), name: '書籍2', count: 1))
Book.create!(id: 3, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(1), name: '隠し書籍', count: 1, status: :hidden))
