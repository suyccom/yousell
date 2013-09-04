class HoboMigration32 < ActiveRecord::Migration
  def self.up
    create_table :payment_methods do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :payment_methods
  end
end
