# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to make a sale', :driver => :selenium do

  before do
    # Create a product type and a couple of variations
    User.current_user = User.last
    @provider1 = FactoryGirl.create(:provider, :name => 'Proveedor1')
    @provider2 = FactoryGirl.create(:provider, :name => 'Proveedor2')
    @pt1 = FactoryGirl.create(:product_type, :name => '300')
    @pt2 = FactoryGirl.create(:product_type, :name => '400')
    @product1 = FactoryGirl.create(:product, :product_type => @pt1, :price => 15, :provider_id => @provider1.id)
    @product2 = FactoryGirl.create(:product, :product_type => @pt2, :price => 16, :provider_id => @provider2.id)
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
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")
    # Check that the amount in stock has been reduced
    @product1.amount.should eq 9
    @product2.amount.should eq 8
    
    # Goes to the sale and prints an invoice
    click_on "#{Sale.last.id - 1}"
    click_on 'Print Invoice'
    fill_in 'sale[client_name]', :with => 'Jon Gutierrez'
    fill_in 'sale[tax_number]', :with => '22222222A'
    fill_in 'sale[address]', :with => 'Uribitarte 22'
    fill_in 'sale[zip_code]', :with => '48001'
    fill_in 'sale[city]', :with => 'Bilbao'
    click_on 'Print'
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
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")

    # Goes to the pending day_sales view
    click_on('Administration')
    click_on('Sales')
    page.should have_css('.label.label-important')
    click_on('There are 1 day(s) with pending day sales to be checked')

    # The admin travels in time and creates another Day sale
    # (we need another Day sale at a day to test the next feature)
    Timecop.travel(Date.today + 1.day)
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

    # Clicks on 'day sale' and completes the sale
    page.find('#day_sale_button').click
    click_on('Complete Sale')
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")

    # Goes to the pending day_sales view
    click_on('Administration')
    click_on('Sales')
    page.should have_css('.label.label-important')
    click_on('There are 2 day(s) with pending day sales to be checked')

    # Can see all the 'day_sales' of a specific day
    page.find('td.completed-at-date-view:first a').click
    page.should have_content(Date.today.strftime('%Y-%m-%d'))
    page.should have_css('tr.sale', :count => 1)

    # Can delete pending 'day sales' on 'day_sales index'
    click_on ('Back to pending day sales')
    page.find('tr.sale:nth-child(1)').should have_content(Sale.first.created_at.to_date.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("31")
    page.find('td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.find('tr.sale:nth-child(1)').should have_content(Date.today.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("15")
    page.find('td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should have_content('No pending day sales to be checked')
  end

end
