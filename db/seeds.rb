
def clear_tables_and_create_admin
  User.delete_all
  Warehouse.delete_all
  Variation.delete_all
  ProductType.delete_all
  Product.delete_all
  Sale.delete_all
  Line.delete_all
  Provider.delete_all
  VariationValue.delete_all
  Labelsheet.delete_all
  Voucher.delete_all
  PaymentMethod.delete_all
  warehouse = Warehouse.create(:name => 'SuperShop')
  User.create(:email_address => 'tecnicos@unoycero.com', :name => 'Tecnicos UnoyCero', :password => 'RobotRobot', :administrator => true, :last_added_products => [], :current_warehouse => warehouse)


  # Create some variations. Names are in spanish because they depend on the barcode format in application.rb  
  size = Variation.create(:name => "Talla")
  size.variation_values << VariationValue.new(:name => "35", :code => "35")
  size.variation_values << VariationValue.new(:name => "36", :code => "36")
  size.variation_values << VariationValue.new(:name => "37", :code => "37")
  size.save
  color = Variation.create(:name => "Color")
  color.variation_values << VariationValue.new(:name => "red", :code => "RED")
  color.variation_values << VariationValue.new(:name => "blue", :code => "BLU")
  color.variation_values << VariationValue.new(:name => "green", :code => "GRE")
  color.save
  type = Variation.create(:name => "Tipo")
  type.variation_values << VariationValue.new(:name => "woman", :code => "W")
  type.variation_values << VariationValue.new(:name => "man", :code => "M")
  type.save

  # Create some PaymentMethods
  PaymentMethod.create(:name => 'Cash')
  PaymentMethod.create(:name => 'Credit Card')
  
end
