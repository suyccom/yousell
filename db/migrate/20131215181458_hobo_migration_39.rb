class HoboMigration39 < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :state, :string
    add_column :vouchers, :name, :string
    add_column :vouchers, :payment_id, :integer
    add_column :payment_methods, :voucher, :boolean, :default => false

    remove_column :vouchers, :validity_period

    add_index :vouchers, [:payment_id]
  end

  def self.down
    remove_column :vouchers, :state
    remove_column :vouchers, :name
    remove_column :vouchers, :payment_id
    remove_column :payment_methods, :voucher

    add_column :vouchers, :validity_period, :date

    remove_index :vouchers, :name => :index_vouchers_on_payment_id rescue ActiveRecord::StatementInvalid
  end
end
