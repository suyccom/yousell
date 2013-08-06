class HoboMigration21 < ActiveRecord::Migration
  def self.up
    remove_column :product_types, :default_price
  end

  def self.down
    add_column :product_types, :default_price, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end
