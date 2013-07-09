class HoboMigration11 < ActiveRecord::Migration
  def self.up
    add_column :sells, :complete, :boolean, :default => false
    add_column :sells, :completed_at, :datetime
  end

  def self.down
    remove_column :sells, :complete
    remove_column :sells, :completed_at
  end
end
