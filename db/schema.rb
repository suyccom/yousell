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

ActiveRecord::Schema.define(:version => 20130721233228) do

  create_table "lines", :force => true do |t|
    t.string   "name"
    t.decimal  "price",      :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sale_id"
    t.integer  "product_id"
    t.integer  "amount",                                   :default => 1
  end

  add_index "lines", ["product_id"], :name => "index_lines_on_product_id"
  add_index "lines", ["sale_id"], :name => "index_lines_on_sale_id"

  create_table "product_type_variations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.integer  "variation_id"
  end

  add_index "product_type_variations", ["product_type_id"], :name => "index_product_type_variations_on_product_type_id"
  add_index "product_type_variations", ["variation_id"], :name => "index_product_type_variations_on_variation_id"

  create_table "product_types", :force => true do |t|
    t.string   "name"
    t.decimal  "default_price", :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variations", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "variation_id"
    t.integer  "product_id"
  end

  add_index "product_variations", ["product_id"], :name => "index_product_variations_on_product_id"
  add_index "product_variations", ["variation_id"], :name => "index_product_variations_on_variation_id"

  create_table "products", :force => true do |t|
    t.decimal  "price",           :precision => 8, :scale => 2, :default => 0.0
    t.integer  "amount"
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.string   "name"
    t.string   "provider_code"
    t.integer  "provider_id"
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
    t.boolean  "complete",                                   :default => false
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "day_sale",                                   :default => false
    t.decimal  "sale_total",   :precision => 8, :scale => 2, :default => 0.0
  end

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
  end

  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "variations", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
