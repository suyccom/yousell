class HoboMigration18 < ActiveRecord::Migration
  def self.up
    change_column :lines, :type_discount, :string, :limit => 255, :default => "%"
  end

  def self.down
    change_column :lines, :type_discount, :string
  end
end
