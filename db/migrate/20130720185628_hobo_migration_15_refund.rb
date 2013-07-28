class HoboMigration15Refund < ActiveRecord::Migration
  def self.up
    add_column :sales, :refunded_ticket_id, :integer

    add_index :sales, [:refunded_ticket_id]
  end

  def self.down
    remove_column :sales, :refunded_ticket_id

    remove_index :sales, :name => :index_sales_on_refunded_ticket_id rescue ActiveRecord::StatementInvalid
  end
end
