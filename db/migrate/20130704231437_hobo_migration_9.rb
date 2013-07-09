class HoboMigration9 < ActiveRecord::Migration
  def self.up
    add_column :lines, :amount, :integer, :default => 1
    change_column :lines, :price, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :lines, :amount
    change_column :lines, :price, :decimal
  end
end
