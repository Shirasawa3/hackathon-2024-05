class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :employee_id, null: false
      t.string :email, null: false
      t.string :slack_channel

      t.timestamps
    end

    add_index :users, :employee_id, unique: true
    add_index :users, :email, unique: true
  end
end
