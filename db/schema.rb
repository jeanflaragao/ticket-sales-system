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

ActiveRecord::Schema[7.1].define(version: 2026_01_18_231753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "show_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "show_id"], name: "index_order_items_on_order_id_and_show_id", unique: true
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["show_id"], name: "index_order_items_on_show_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_email", null: false
    t.string "status", default: "pending", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["customer_email"], name: "index_orders_on_customer_email"
    t.index ["status"], name: "index_orders_on_status"
  end

  create_table "shows", force: :cascade do |t|
    t.string "name", null: false
    t.integer "total_inventory", default: 0, null: false
    t.integer "reserved_inventory", default: 0, null: false
    t.integer "sold_inventory", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shows_on_name"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "shows"
end
