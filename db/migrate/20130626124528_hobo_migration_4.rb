class HoboMigration4 < ActiveRecord::Migration
  def self.up
    rename_column :product_types, :default_value, :default_price
  end

  def self.down
    rename_column :product_types, :default_price, :default_value
  end
end
