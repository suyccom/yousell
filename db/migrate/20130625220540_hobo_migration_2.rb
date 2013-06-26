class HoboMigration2 < ActiveRecord::Migration
  def self.up
    create_table :variations do |t|
      t.string   :name
      t.string   :value
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :variations
  end
end
