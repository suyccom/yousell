class HoboMigration26 < ActiveRecord::Migration
  def self.up
    add_column :users, :current_warehouse_id, :integer

    add_index :users, [:current_warehouse_id]
  end

  def self.down
    remove_column :users, :current_warehouse_id

    remove_index :users, :name => :index_users_on_current_warehouse_id rescue ActiveRecord::StatementInvalid
  end
end
