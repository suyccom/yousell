class CreateProductWarehouses < ActiveRecord::Migration
  def up
    for product in Product.all
      product.create_product_warehouses
    end
  end

  def down
  end
end
