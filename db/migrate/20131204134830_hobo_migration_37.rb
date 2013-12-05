class HoboMigration37 < ActiveRecord::Migration
  def self.up
    add_column :products, :metadata, :string
  end

  def self.down
    remove_column :products, :metadata
  end
end
