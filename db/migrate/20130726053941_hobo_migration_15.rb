class HoboMigration15 < ActiveRecord::Migration
  def self.up
    remove_column :sales, :day_sale
    remove_column :sales, :sale_total

    add_column :products, :warehouse_id, :integer

    add_index :products, [:warehouse_id]
  end

  def self.down
    add_column :sales, :day_sale, :boolean, :default => false
    add_column :sales, :sale_total, :decimal, :precision => 8, :scale => 2, :default => 0.0

    remove_column :products, :warehouse_id

    remove_index :products, :name => :index_products_on_warehouse_id rescue ActiveRecord::StatementInvalid
  end
end
