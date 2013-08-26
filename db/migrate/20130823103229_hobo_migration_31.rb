class HoboMigration31 < ActiveRecord::Migration
  def self.up
    add_column :users, :company_name, :string
    add_column :users, :company_address, :text
  end

  def self.down
    remove_column :users, :company_name
    remove_column :users, :company_address
  end
end
