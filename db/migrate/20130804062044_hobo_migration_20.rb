class HoboMigration20 < ActiveRecord::Migration
  def self.up
    drop_table :product_type_variations
  end

  def self.down
    create_table "product_type_variations", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "product_type_id"
      t.integer  "variation_id"
    end

    add_index "product_type_variations", ["product_type_id"], :name => "index_product_type_variations_on_product_type_id"
    add_index "product_type_variations", ["variation_id"], :name => "index_product_type_variations_on_variation_id"
  end
end
