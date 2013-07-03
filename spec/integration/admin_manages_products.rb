# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage products', :driver => :selenium do

  before do
    # Create a product type and a couple of variations
    size = Variation.create(:name => "Size", :value => "35,36,37")
    color = Variation.create(:name => "Color", :value => "red,blue,green")
    pt = ProductType.new(:name => "Shoes", :default_price => 10)
    pt.variations << size
    pt.variations << color
    pt.save
  end

  scenario 'Admin adds, removes and edits products' do
    # The user goes to the products index and sees it empty
    login
    click_on('Stock')
    page.should_not have_css('tr.products')
    # Adds a product
    click_on 'New Product'
    select 'Shoes'
    select '36'
    select 'green'
    fill_in 'product[amount]', :with => '10'
    fill_in 'product[barcode]', :with => '123456789'
    click_on 'Create Product'
    # Checks that the product has been successfully created
    page.find('tr.product:nth-child(1) .amount-view').should have_content '10'
    page.find('tr.product:nth-child(1) .name-view').should have_content 'Shoes 36 green'
    # Edits the product and changes the amount to 12
    page.find('tr.product:nth-child(1) .icon-edit').click
    fill_in 'product[amount]', :with => '12'
    click_on 'Save Product'
    page.find('tr.product:nth-child(1) .amount-view').should have_content '12'
    # Removes the product
    page.find('tr.product:nth-child(1) .icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should_not have_css('tr.products')
  end

end
