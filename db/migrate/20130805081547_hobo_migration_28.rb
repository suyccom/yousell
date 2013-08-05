class HoboMigration28 < ActiveRecord::Migration
  def self.up
    add_column :users, :last_added_products, :string
  end

  def self.down
    remove_column :users, :last_added_products
  end
end
