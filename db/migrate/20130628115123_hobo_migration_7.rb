class HoboMigration7 < ActiveRecord::Migration
  def self.up
    create_table :product_variations do |t|
      t.string   :value
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :variation_id
      t.integer  :product_id
    end
    add_index :product_variations, [:variation_id]
    add_index :product_variations, [:product_id]

    add_column :products, :product_type_id, :integer

    add_index :products, [:product_type_id]
  end

  def self.down
    remove_column :products, :product_type_id

    drop_table :product_variations

    remove_index :products, :name => :index_products_on_product_type_id rescue ActiveRecord::StatementInvalid
  end
end
