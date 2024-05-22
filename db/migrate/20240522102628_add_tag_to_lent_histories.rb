class AddTagToLentHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :lent_histories, :tag, :string
  end
end
