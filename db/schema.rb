# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_22_063624) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.bigint "item_basic_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_basic_info_id"], name: "index_books_on_item_basic_info_id"
  end

  create_table "corporate_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_corporate_users_on_email", unique: true
    t.index ["employee_id"], name: "index_corporate_users_on_employee_id", unique: true
    t.index ["reset_password_token"], name: "index_corporate_users_on_reset_password_token", unique: true
  end

  create_table "headsets", force: :cascade do |t|
    t.bigint "item_basic_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_basic_info_id"], name: "index_headsets_on_item_basic_info_id"
  end

  create_table "item_basic_infos", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "max_lent_period"
    t.bigint "item_type_id", null: false
    t.integer "count"
    t.string "tags", array: true
    t.integer "status", default: 0, null: false
    t.integer "item_basic_info_status", default: 0, null: false
    t.boolean "is_extendable", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type_id"], name: "index_item_basic_infos_on_item_type_id"
    t.index ["name", "item_type_id"], name: "index_item_basic_infos_on_name_and_item_type_id", unique: true
  end

  create_table "item_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_item_types_on_name", unique: true
  end

  create_table "lent_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "item_basic_info_id", null: false
    t.datetime "lent_at", null: false
    t.datetime "period", null: false
    t.datetime "returned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_basic_info_id"], name: "index_lent_histories_on_item_basic_info_id"
    t.index ["user_id"], name: "index_lent_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "employee_id", null: false
    t.string "email", null: false
    t.string "slack_channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id", unique: true
  end

  add_foreign_key "books", "item_basic_infos"
  add_foreign_key "headsets", "item_basic_infos"
  add_foreign_key "item_basic_infos", "item_types"
  add_foreign_key "lent_histories", "item_basic_infos"
  add_foreign_key "lent_histories", "users"
end
