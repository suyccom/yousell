class HoboMigration40GuardarVentaEnVale < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :sale_id, :integer
  end

  def self.down
    remove_column :vouchers, :sale_id
  end
end
