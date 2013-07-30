class HoboMigration19 < ActiveRecord::Migration
  def self.up
    change_column :sales, :total_discount, :integer, :default => 0
    change_column :sales, :type_discount, :string, :limit => 255, :default => "%"
  end

  def self.down
    change_column :sales, :total_discount, :integer
    change_column :sales, :type_discount, :string
  end
end
