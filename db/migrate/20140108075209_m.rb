class M < ActiveRecord::Migration
  def self.up
    add_column :products, :generic, :boolean, :default => false
  end

  def self.down
    remove_column :products, :generic
  end
end
