class CreateHeadsets < ActiveRecord::Migration[7.0]
  def change
    create_table :headsets do |t|
      t.references :item_basic_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
