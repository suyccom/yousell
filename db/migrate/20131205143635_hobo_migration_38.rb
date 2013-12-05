class HoboMigration38 < ActiveRecord::Migration
  def self.up
    add_column :products, :metabusqueda, :string
    remove_column :products, :metadata
  end

  def self.down
    remove_column :products, :metabusqueda
    add_column :products, :metadata, :string
  end
end
