class GuardarMetabusquedas < ActiveRecord::Migration
  def up
    for p in Product.all
      variations = ""
      for v in p.product_variations
        if v.value != I18n.t('product.wihout_variation')
          variations = "#{variations} #{v.value}"
        end
      end
      p.update_column(:metabusqueda, "#{p.provider} #{p.product_type.name} #{variations} #{p.description}")
    end
  end

  def down
  end
end
