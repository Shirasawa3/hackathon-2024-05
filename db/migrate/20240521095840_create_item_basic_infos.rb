class CreateItemBasicInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :item_basic_infos do |t|
      t.string :name, null: false
      t.datetime :max_lent_period, default: nil
      t.references :item_type, null: false, foreign_key: true
      t.integer :count
      t.string :tags, array: true
      t.integer :status, :item_basic_info_status, null: false, default: 0
      t.boolean :is_extendable, null: false, default: true

      t.timestamps
    end

    add_index :item_basic_infos, [:name, :item_type_id], unique: true
  end
end
