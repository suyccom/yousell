class HoboMigration29 < ActiveRecord::Migration
  def self.up
    create_table :labelsheets do |t|
      t.string   :name_printer
      t.string   :name_labelsheet
      t.integer  :rows
      t.integer  :columns
      t.float    :top_margin
      t.float    :bottom_margin
      t.float    :left_margin
      t.float    :right_margin
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :labelsheets
  end
end
