# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130911161059) do

  create_table "labelsheets", :force => true do |t|
    t.string   "name_printer"
    t.string   "name_labelsheet"
    t.integer  "rows"
    t.integer  "columns"
    t.float    "top_margin"
    t.float    "bottom_margin"
    t.float    "left_margin"
    t.float    "right_margin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", :force => true do |t|
    t.string   "name"
    t.decimal  "price",         :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sale_id"
    t.integer  "product_id"
    t.integer  "amount",                                      :default => 1
    t.integer  "discount",                                    :default => 0
    t.string   "type_discount",                               :default => "%"
  end

  add_index "lines", ["product_id"], :name => "index_lines_on_product_id"
  add_index "lines", ["sale_id"], :name => "index_lines_on_sale_id"

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sale_id"
    t.integer  "payment_method_id"
    t.decimal  "amount",            :precision => 8, :scale => 2, :default => 0.0
  end

  add_index "payments", ["payment_method_id"], :name => "index_payments_on_payment_method_id"
  add_index "payments", ["sale_id"], :name => "index_payments_on_sale_id"

  create_table "product_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variations", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "variation_id"
    t.integer  "product_id"
    t.string   "code"
  end

  add_index "product_variations", ["product_id"], :name => "index_product_variations_on_product_id"
  add_index "product_variations", ["variation_id"], :name => "index_product_variations_on_variation_id"

  create_table "product_warehouses", :force => true do |t|
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warehouse_id"
    t.integer  "product_id"
  end

  add_index "product_warehouses", ["product_id"], :name => "index_product_warehouses_on_product_id"
  add_index "product_warehouses", ["warehouse_id"], :name => "index_product_warehouses_on_warehouse_id"

  create_table "products", :force => true do |t|
    t.decimal  "price",           :precision => 8, :scale => 2, :default => 0.0
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.string   "name"
    t.integer  "provider_id"
    t.string   "description"
  end

  add_index "products", ["product_type_id"], :name => "index_products_on_product_type_id"
  add_index "products", ["provider_id"], :name => "index_products_on_provider_id"

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "sales", :force => true do |t|
    t.boolean  "complete",                                         :default => false
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "refunded_ticket_id"
    t.integer  "total_discount",                                   :default => 0
    t.string   "type_discount",                                    :default => "%"
    t.boolean  "day_sale",                                         :default => false
    t.decimal  "sale_total",         :precision => 8, :scale => 2, :default => 0.0
    t.string   "client_name"
    t.string   "tax_number"
    t.string   "address"
    t.string   "zip_code"
    t.string   "city"
  end

  add_index "sales", ["refunded_ticket_id"], :name => "index_sales_on_refunded_ticket_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
    t.string   "language",                                :default => "en"
    t.integer  "current_warehouse_id"
    t.string   "last_added_products"
    t.string   "company_name"
    t.text     "company_address"
  end

  add_index "users", ["current_warehouse_id"], :name => "index_users_on_current_warehouse_id"
  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "variation_values", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "variation_id"
  end

  add_index "variation_values", ["variation_id"], :name => "index_variation_values_on_variation_id"

  create_table "variations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vouchers", :force => true do |t|
    t.date     "validity_period"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
