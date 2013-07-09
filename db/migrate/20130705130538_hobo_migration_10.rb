class HoboMigration10 < ActiveRecord::Migration
  def self.up
    add_column :products, :name, :string
  end

  def self.down
    remove_column :products, :name
  end
end
