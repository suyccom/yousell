class HoboMigration15 < ActiveRecord::Migration
  def self.up
    add_column :lines, :discount, :string

    add_column :sales, :total_discount, :string
  end

  def self.down
    remove_column :lines, :discount

    remove_column :sales, :total_discount
  end
end
