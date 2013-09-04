class HoboMigration32 < ActiveRecord::Migration
  def self.up
    create_table :vouchers do |t|
      t.date     :validity_period
      t.float    :amount
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :vouchers
  end
end
