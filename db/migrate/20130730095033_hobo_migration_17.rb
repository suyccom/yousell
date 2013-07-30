class HoboMigration17 < ActiveRecord::Migration
  def self.up
    change_column :lines, :discount, :integer, :default => 0
  end

  def self.down
    change_column :lines, :discount, :integer
  end
end
