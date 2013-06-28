class HoboMigration6 < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.decimal  :price
      t.integer  :amount
      t.string   :barcode
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :products
  end
end
