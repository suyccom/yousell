class HoboMigration35 < ActiveRecord::Migration
  def self.up
    add_column :payments, :amount, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :payments, :completed, :boolean, :default => false
    remove_column :payments, :ammount
  end

  def self.down
    remove_column :payments, :amount
    remove_column :payments, :completed
    add_column :payments, :ammount, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end
