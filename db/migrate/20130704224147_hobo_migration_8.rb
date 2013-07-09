class HoboMigration8 < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.string   :name
      t.decimal  :price
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :sell_id
      t.integer  :product_id
    end
    add_index :lines, [:sell_id]
    add_index :lines, [:product_id]

    create_table :sells do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :products, :price, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    change_column :products, :price, :decimal

    drop_table :lines
    drop_table :sells
  end
end
