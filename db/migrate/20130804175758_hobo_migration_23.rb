class HoboMigration23 < ActiveRecord::Migration
  def self.up
    create_table :variation_values do |t|
      t.string   :name
      t.string   :code
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :variation_id
    end
    add_index :variation_values, [:variation_id]

    remove_column :variations, :value
  end

  def self.down
    add_column :variations, :value, :string

    drop_table :variation_values
  end
end
