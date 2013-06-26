class HoboMigration3 < ActiveRecord::Migration
  def self.up
    create_table :product_types do |t|
      t.string   :name
      t.decimal  :default_value, :precision => 8, :scale => 2, :default => 0
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :product_types
  end
end
