class HoboMigration36 < ActiveRecord::Migration
  def self.up
    remove_column :payments, :completed
  end

  def self.down
    add_column :payments, :completed, :boolean, :default => false
  end
end
