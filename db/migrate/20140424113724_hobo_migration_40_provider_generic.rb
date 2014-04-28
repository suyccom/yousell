class HoboMigration40ProviderGeneric < ActiveRecord::Migration
  def self.up
    remove_column :products, :generic

    add_column :providers, :generic, :boolean, :default => false

    change_column :product_warehouses, :amount, :integer, :default => nil
  end

  def self.down
    add_column :products, :generic, :boolean, :default => false

    remove_column :providers, :generic

    change_column :product_warehouses, :amount, :integer, :default => 0
  end
end
