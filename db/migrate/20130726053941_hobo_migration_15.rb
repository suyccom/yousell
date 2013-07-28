class HoboMigration15 < ActiveRecord::Migration
  def self.up
    add_column :products, :warehouse_id, :integer

    add_index :products, [:warehouse_id]
  end

  def self.down
    remove_column :products, :warehouse_id

    remove_index :products, :name => :index_products_on_warehouse_id rescue ActiveRecord::StatementInvalid
  end
end
