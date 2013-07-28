class HoboMigration15Daysale < ActiveRecord::Migration
  def self.up
    add_column :sales, :day_sale, :boolean, :default => false
  end

  def self.down
    remove_column :sales, :day_sale
  end
end
