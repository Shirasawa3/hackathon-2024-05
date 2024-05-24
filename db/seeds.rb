# frozen_string_literal: true

(1..5).each do |i|
  User.create!(id: i, first_name: "太郎#{i}号", last_name: '開発', employee_id: "D#{i}", email: "dev-#{i}@techouse.jp", department: '本部')
end

CorporateUser.create!(id: 1, first_name: '玲人', last_name: '工保', employee_id: 'C1', email: 'corporate@techouse.jp', password: 'password')

(1..30).each do |i|
  Book.create!(id: i, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(1), name: "書籍#{i}", count: i))
end

book = Book.find(3)
book_info = book.item_basic_info

Book.create!(id: 101, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(1), name: '隠し書籍', count: 1, status: :hidden))

Headset.create!(id: 1, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(2), name: 'ヘッドセット型番A', tags: (1..30).map { |i| "TEC-A#{sprintf('%03d', i)}" }))
Headset.create!(id: 2, item_basic_info: ItemBasicInfo.new(item_type: ItemType.find(2), name: 'ヘッドセット型番B', tags: ['TEC-B001']))

first_headset = Headset.first!
first_headset_info = first_headset.item_basic_info

LentHistory.create!(id: 1, user_id: 1, item_basic_info: book_info, lent_at: '1963/11/18', period: '1988/09/23', returned_at: '2001/01/14')
LentHistory.create!(id: 2, user_id: 1, item_basic_info: book_info, lent_at: '2000/01/01', period: '2100/12/31')
LentHistory.create!(id: 3, user_id: 1, item_basic_info: first_headset_info, lent_at: '2000/01/01', tag: 'TEC-A002', period: '2100/12/31')
