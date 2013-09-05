class HoboMigration34 < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal  :ammount, :precision => 8, :scale => 2, :default => 0
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :sale_id
      t.integer  :payment_method_id
    end
    add_index :payments, [:sale_id]
    add_index :payments, [:payment_method_id]
  end

  def self.down
    drop_table :payments
  end
end
