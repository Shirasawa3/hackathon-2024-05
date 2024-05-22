class AddIndexToItemTypes < ActiveRecord::Migration[7.0]
  def change
    add_index :item_types, :name, unique: true
  end
end
