class HoboMigration27 < ActiveRecord::Migration
  def self.up
    create_table :product_warehouses do |t|
      t.integer  :amount
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :warehouse_id
      t.integer  :product_id
    end
    add_index :product_warehouses, [:warehouse_id]
    add_index :product_warehouses, [:product_id]

    remove_column :products, :amount
    remove_column :products, :warehouse_id

    remove_index :products, :name => :index_products_on_warehouse_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :products, :amount, :integer
    add_column :products, :warehouse_id, :integer

    drop_table :product_warehouses

    add_index :products, [:warehouse_id]
  end
end
