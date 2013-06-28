class HoboMigration5 < ActiveRecord::Migration
  def self.up
    create_table :product_type_variations do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_type_id
      t.integer  :variation_id
    end
    add_index :product_type_variations, [:product_type_id]
    add_index :product_type_variations, [:variation_id]
  end

  def self.down
    drop_table :product_type_variations
  end
end
