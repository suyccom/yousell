# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage products', :driver => :selenium do

  before do
    # Create a warehouse and a provider
    @shop = Warehouse.last
    @warehouse = Warehouse.create!(:name => 'Deusto')
    @provider = Provider.create!(:name => 'SuperZapas', :code => 'SZ')
    login
  end

  scenario 'Admin adds, removes and edits products' do
    # The admin adds two new products in one screen
    click_on 'Stock'
    click_on 'Add products'
    within '.product:nth-child(1)' do
      select 'SuperZapas'
      fill_in 'product_type[products][][code]', :with => '300'
      find_field('product_type[products][][product_warehouses][][amount]').value.should == '1'
      select '35'
      select 'red'
      select 'woman'
    end
    page.find('.add-product-button').click
    within '.product:nth-child(2)' do
      find_field('product_type[products][][provider_id]').value.should == @provider.id.to_s
      find_field('product_type[products][][code]').value.should == '300'
      find_field('product_type[products][][product_warehouses][][amount]').value.should == '1'
      find_field('product_type[products][][product_warehouses][][warehouse_id]').value.should == @shop.id.to_s
      select '36'
    end
    click_on 'Save'
    page.should have_css('tr.product', :count => 2)
    page.find('tr.product:nth-child(1) .this-view').should have_content 'SuperZapas 300 35 red woman'
    page.find('tr.product:nth-child(1) .amount-view').should have_content '1 (SuperShop 1)'
    page.find('tr.product:nth-child(1) .barcode-view').should have_content 'SZW0300RED35'
    
    # Edits the product price
    page.find('tr.product:nth-child(1) .icon-edit').click
    fill_in 'product[price]', :with => '20'
    click_on 'Save Product'
    click_on 'Stock'
    page.find('tr.product:nth-child(1) .price-view').should have_content '$20.00'

    # The admin adds one unit of a product using a barcode
    click_on 'Add products'
    fill_in 'barcode', :with => 'SZW0300GRE37'
    page.find('.add-product-button').click
    page.should have_css('.product', :count => 2)
    click_on 'Save'
    click_on 'Stock'
    page.should have_css('tr.product', :count => 3)
    page.find('tr.product:nth-child(3) .this-view').should have_content 'SuperZapas 300 37 green woman'
    page.find('tr.product:nth-child(1) .amount-view').should have_content '1 (SuperShop 1)'
    
    # The admin adds one unit of a product that already exists in the DB (it should be summed)
    click_on 'Add products'
    fill_in 'barcode', :with => 'SZW0300GRE37'
    page.find('.add-product-button').click
    page.should have_css('.product', :count => 2)
    click_on 'Save'
    click_on 'Stock'
    page.should have_css('tr.product', :count => 3)
    page.find('tr.product:nth-child(3) .this-view').should have_content 'SuperZapas 300 37 green woman'
    page.find('tr.product:nth-child(3) .amount-view').should have_content '2 (SuperShop 2)'
    
    # Removes the last product
    page.find('tr.product:nth-child(3) .icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should have_css('tr.product', :count => 2)

    # Prints some labels
    click_on 'SuperZapas 300 35 red woman'
    click_on 'Print Labels'
    # a message with no labelsheet defined should appear
    page.should have_content('Please add your labelsheets first. Go to Administration, Labelsheets to add some.')
    # adds a labelsheet
    click_on 'Administration'
    click_on 'Labelsheets'
    click_on 'New Labelsheet'
    fill_in 'labelsheet[name_printer]', :with => 'Brother'
    fill_in 'labelsheet[name_labelsheet]', :with => 'Apli1285'
    fill_in 'labelsheet[rows]', :with => '10'
    fill_in 'labelsheet[columns]', :with => '4'
    fill_in 'labelsheet[top_margin]', :with => '65.0'
    fill_in 'labelsheet[bottom_margin]', :with => '55.0'
    fill_in 'labelsheet[left_margin]', :with => '40.5'
    fill_in 'labelsheet[right_margin]', :with => '15.5'
    click_on 'Create Labelsheet'
    # finally can print labels
    click_on 'Stock'
    click_on 'SuperZapas 300 35 red woman'
    click_on 'Print Labels'
    fill_in 'empty_cells', :with => '0'
    select 'Brother Apli1285'
    click_on 'Print'
    page.should have_content 'The labels have been sent to the printer'
  end

end

