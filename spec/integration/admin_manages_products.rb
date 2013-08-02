# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage products', :driver => :selenium do

  before do
    # Create a product type, a couple of variations, a warehouse and a provider
    size = Variation.create(:name => "Size", :value => "35,36,37")
    color = Variation.create(:name => "Color", :value => "red,blue,green")
    pt = ProductType.new(:name => "Shoes", :default_price => 10)
    pt.variations << size
    pt.variations << color
    pt.save
    Warehouse.create!(:name => 'The big one')
    Warehouse.create!(:name => 'The small one')
    provider = Provider.create!(:name => 'SuperZapas', :code => 'SZ')
  end

  scenario 'Admin adds, removes and edits products' do
    # The user goes to the products index and sees it empty
    login
    click_on('Stock')
    page.should_not have_css('tr.products')
    # Adds a product
    click_on 'New Product'
    select 'Shoes'
    sleep 0.5
    select 'SuperZapas'
    fill_in 'product[provider_code]', :with => 'SZ-1'
    select '36'
    select 'green'
    fill_in 'product[amount]', :with => '10'
    select 'The big one'
    click_on 'Create Product'
    # Checks that the product has been successfully created
    click_on 'Stock'
    page.find('tr.product:nth-child(1) .amount-view').should have_content '10'
    page.find('tr.product:nth-child(1) .this-view').should have_content 'Shoes 36 green'
    page.find('tr.product:nth-child(1) .barcode-view').should have_content 'SZSZ-1'
    page.find('tr.product:nth-child(1) .warehouse-view').should have_content 'The big one'
    # Checks that Warehouse filter works well
    select 'The small one'
    page.should have_content 'No records to display'
    select 'The big one'
    page.find('tr.product:nth-child(1) .warehouse-view').should have_content 'The big one'
    # Edits the product and changes the amount to 12
    page.find('tr.product:nth-child(1) .icon-edit').click
    fill_in 'product[amount]', :with => '12'
    click_on 'Save Product'
    click_on 'Stock'
    page.find('tr.product:nth-child(1) .amount-view').should have_content '12'
    # Tries to create another product with the same provider code
    click_on 'New Product'
    select 'Shoes'
    select 'SuperZapas'
    sleep 0.5
    fill_in 'product[provider_code]', :with => 'SZ-1'
    select '35'
    select 'blue'
    fill_in 'product[amount]', :with => '5'
    click_on 'Create Product'
    page.should have_content 'code has already been taken.'
    click_on 'Click here to go to the product with provider code SZ-1'
    page.should have_content 'Shoes 36 green'
    # Prints some labels
    click_on 'Print Labels'
    fill_in 'number', :with => '2'
    fill_in 'empty_cells', :with => '0'
    click_on 'Print'
    page.should have_content 'The labels have been sent to the printer'
    # Removes the product
    visit '/products'
    page.find('tr.product:nth-child(1) .icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should_not have_css('tr.products')
  end

end

