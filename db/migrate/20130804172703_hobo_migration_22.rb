class HoboMigration22 < ActiveRecord::Migration
  def self.up
    remove_column :products, :provider_code
  end

  def self.down
    add_column :products, :provider_code, :string
  end
end
