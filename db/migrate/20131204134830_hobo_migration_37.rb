class HoboMigration37 < ActiveRecord::Migration
  def self.up
    add_column :products, :metadata, :string
    for p in Product.all
      for v in p.product_variations
        if v.value != I18n.t('product.wihout_variation')
          variations = "#{variations} #{v.value}"
        end
      end
      p.update_column(:metadata, "#{p.provider} #{p.product_type.name} #{variations} #{p.description}")
    end
  end

  def self.down
    remove_column :products, :metadata
  end
end
