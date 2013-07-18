class HoboMigration14 < ActiveRecord::Migration
  def self.up
    add_column :providers, :code, :string
  end

  def self.down
    remove_column :providers, :code
  end
end
