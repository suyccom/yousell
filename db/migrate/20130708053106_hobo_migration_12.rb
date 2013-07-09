class HoboMigration12 < ActiveRecord::Migration
  def self.up
    drop_table :sells

    create_table :sales do |t|
      t.boolean  :complete, :default => false
      t.datetime :completed_at
      t.datetime :created_at
      t.datetime :updated_at
    end

    rename_column :lines, :sell_id, :sale_id

    remove_index :lines, :name => :index_lines_on_sell_id rescue ActiveRecord::StatementInvalid
    add_index :lines, [:sale_id]
  end

  def self.down
    rename_column :lines, :sale_id, :sell_id

    create_table "sells", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "complete",     :default => false
      t.datetime "completed_at"
    end

    drop_table :sales

    remove_index :lines, :name => :index_lines_on_sale_id rescue ActiveRecord::StatementInvalid
    add_index :lines, [:sell_id]
  end
end
