class HoboMigration25 < ActiveRecord::Migration
  def self.up
    add_column :product_variations, :code, :string
  end

  def self.down
    remove_column :product_variations, :code
  end
end
