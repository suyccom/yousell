class HoboMigration30 < ActiveRecord::Migration
  def self.up
    add_column :sales, :client_name, :string
    add_column :sales, :tax_number, :string
    add_column :sales, :address, :string
    add_column :sales, :zip_code, :string
    add_column :sales, :city, :string
  end

  def self.down
    remove_column :sales, :client_name
    remove_column :sales, :tax_number
    remove_column :sales, :address
    remove_column :sales, :zip_code
    remove_column :sales, :city
  end
end
