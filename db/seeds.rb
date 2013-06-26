
def clear_tables_and_create_admin
  User.delete_all
  Warehouse.delete_all
  Variation.delete_all
  ProductType.delete_all
  User.create(:email_address => 'tecnicos@unoycero.com', :name => 'Tecnicos UnoyCero', :password => 'RobotRobot', :administrator => true)
end
