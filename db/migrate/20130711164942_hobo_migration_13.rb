class HoboMigration13 < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :products, :provider_code, :string
    add_column :products, :provider_id, :integer

    add_index :products, [:provider_id]
  end

  def self.down
    remove_column :products, :provider_code
    remove_column :products, :provider_id

    drop_table :providers

    remove_index :products, :name => :index_products_on_provider_id rescue ActiveRecord::StatementInvalid
  end
end
