# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to make a sale', :driver => :selenium do

  before do
    # Create a product type and a couple of variations
    User.current_user = User.last
    @pt1 = FactoryGirl.create(:product_type, :name => '300')
    @pt2 = FactoryGirl.create(:product_type, :name => '400')
    @product1 = FactoryGirl.create(:product, :product_type => @pt1, :price => 15)
    @product2 = FactoryGirl.create(:product, :product_type => @pt2, :price => 16)
  end

  scenario 'Admin makes a sale' do
    login
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => @product1.barcode)
      click_on('+')
    end
    sleep 0.3
    page.should have_css 'tr.line:nth-child(1)'
    page.find('tr.line:nth-child(1)').should have_content @product1.name
    page.should have_content '$15.00'

    # Adds another product
    within '#add-product-form' do
      fill_in('search', :with => '400')
      click_on(@product2.name.strip)
      click_on('+')
    end
    #page.should have_css 'tr.line:nth-child(2)'
    page.find('tr.line:nth-child(2)').should have_content @product2.name
    page.should have_content('$31.00')

    # Adds another pair of white shoes
    within 'tr.line:nth-child(2)' do
      page.find(".icon-plus").click
    end
    page.should have_content('$47.00')
    
    # Adds an incorrect barcode
    fill_in('search', :with => '')
    fill_in('barcode', :with => '11GREEN')
    click_on('+')
    page.should have_css 'tr.line', :count => 2
    page.driver.browser.switch_to.alert.accept

    click_on('Complete Sale')
    page.should have_content('The sale has been completed successfully')
    # Check that the amount in stock has been reduced
    @product1.amount.should eq 9
    @product2.amount.should eq 8
  end




  scenario 'Admin makes a day sale' do
    login
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => @product1.barcode)
      click_on('+')
    end
    page.should have_css('tr.line:nth-child(1)')
    page.find('tr.line:nth-child(1)').should have_content(@product1.name)
    page.should have_content('$15.00')

    # Clicks on 'day sale', but after that adds more products and discounts and the button should remain pushed

    within '#add-product-form' do
      fill_in('barcode', :with => @product2.barcode)
      click_on('+')
    end
    page.should have_css('tr.line:nth-child(2)')
    page.should have_content('$31.00')
    page.find('#day_sale_button').click

    # ...and completes the sale
    click_on('Complete Sale')
    page.should have_content('The sale has been completed successfully')

    # Can sees/deletes pending 'day sales'
    click_on('Administration')
    click_on('Sales')
    page.should have_css('.label.label-important')
    click_on('There are pending day sales: 1')
    page.should have_css('tr.sale:nth-child(1)')
    page.find('tr.sale:nth-child(1)').should have_content(Date.today.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("31")
    page.find('td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should have_content('No pending day sales')
  end

end
