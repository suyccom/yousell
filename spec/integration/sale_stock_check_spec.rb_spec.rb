# encoding: UTF-8

require 'spec_helper'

feature 'Sale stock checks', :driver => :selenium do

  before do
    User.current_user = User.last
    @product = FactoryGirl.create(:product)
    login
  end

  scenario 'The admin can not add a product without stock' do
    @product.current_product_warehouse.update_attribute(:amount, 0)
    visit '/'
    within '#add-product-form' do
      fill_in 'barcode', :with => @product.barcode
      click_on '+'
    end
    # Accept the error alert
    page.driver.browser.switch_to.alert.accept
    page.should_not have_css 'tr.line:nth-child(1)'
  end
  
  scenario 'The admin can not increase the units of a product if there is not enough stock' do
    @product.current_product_warehouse.update_attribute(:amount, 2)
    visit '/'
    within '#add-product-form' do
      fill_in 'barcode', :with => @product.barcode
      click_on '+'
    end
    page.should have_content '$10.00'
    within 'tr.line:nth-child(1)' do
      page.find(".icon-plus").click
    end
    page.should have_content '$20.00'
    within 'tr.line:nth-child(1)' do
      page.find(".icon-plus").click
    end
    # Accept the error alert
    page.driver.browser.switch_to.alert.accept
    
    # The total remains the same
    page.should have_content '$20.00'
  end
  
end

