class HoboMigration16Discounts < ActiveRecord::Migration
  def self.up
    add_column :lines, :type_discount, :string
    change_column :lines, :discount, :integer, :limit => nil
    add_column :sales, :type_discount, :string
    change_column :sales, :total_discount, :integer, :limit => nil
  end

  def self.down
    remove_column :lines, :type_discount
    change_column :lines, :discount, :string
    remove_column :sales, :type_discount
    change_column :sales, :total_discount, :string
  end
end
