class HoboMigration40ProductWarehouseDefault0 < ActiveRecord::Migration
  def self.up
    change_column :product_warehouses, :amount, :integer, :default => 0
  end

  def self.down
    change_column :product_warehouses, :amount, :integer
  end
end
