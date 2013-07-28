class HoboMigration16 < ActiveRecord::Migration
  def self.up
    add_column :sales, :day_sale, :boolean, :default => false
    add_column :sales, :sale_total, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :sales, :day_sale
    remove_column :sales, :sale_total
  end
end
