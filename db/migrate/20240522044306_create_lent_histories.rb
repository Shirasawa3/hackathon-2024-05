class CreateLentHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :lent_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item_basic_info, null: false, foreign_key: true
      t.datetime :lent_at, null: false
      t.datetime :period, null: false
      t.datetime :returned_at

      t.timestamps
    end
  end
end
