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

    # Adds a product via barcode
    within '#add-product-form' do
      fill_in('barcode', :with => @product1.barcode)
      click_button('add-product-by-barcode')
    end
    sleep 0.3
    page.should have_css 'tr.line:nth-child(1)'
    page.find('tr.line:nth-child(1)').should have_content @product1.name
    page.should have_content '$15.00'
    within('tfoot div.discount-group') do
      # We use global discount to discount $1
      page.find('span.total-discount').click
      fill_in('sale_total_discount', :with => '1')
      page.find('button').click
      click_link('€')
    end
    within('span.text-error') do
      page.should have_content('Pending: $14.00')
    end

    # Adds another product via search
    within '#search-product-form' do
      fill_in('search-query', :with => '400')
      sleep(1)
      click_link('search-products')
    end
    select('Proveedor2 400',:from => 'search-products-input')
    click_on('add-products-by-search')
    page.find('tr.line:nth-child(2)').should have_content @product2.name
    page.should have_content('$30.00')

    # Adds another pair of white shoes
    within 'tr.line:nth-child(2)' do
      page.find(".icon-plus").click
    end
    page.should have_content('$46.00')
    
    # Adds an incorrect barcode
    within '#add-product-form' do
      fill_in('barcode', :with => '11GREEN')
      click_on('add-product-by-barcode')
    end
    page.should have_css 'tr.line', :count => 2

    # Selects a Payment Method
    click_on('Cash') 
    within('#payment-modal') do
      fill_in("payment_amount", :with => 10)
      click_on('add-payment-amount')
    end
    sleep 1
    page.find('a#Cash').should have_content('$10.00')
    page.should have_content("Pending: $36.00")
    click_on('complete-sale-button')
    page.should have_content("The sale can't be completed because there is an amount pending to be paid")
    click_on('Cash')
    within('#payment-modal') do
      find_field("payment_amount").value.should == ''
      fill_in("payment_amount", :with => 50)
      click_on('add-payment-amount')
    end
    sleep 1
    Sale.last.payments.size.should eq 1
    Sale.last.payments.last.payment_method.to_s.should eq 'Cash'
    Sale.last.payments.last.amount.to_i.should eq 50
    Sale.last.pending_amount.to_i.should eq -4
    page.find('a#Cash').should have_content('$50.00')
    page.should have_content("Return: $4.00")
    # Admin cancels Cash payment
    click_on('Cash')
    click_on('add-payment-amount')
    sleep 1
    page.find('a#Cash').text.should eq('Cash')
    Sale.last.payments.size.should eq 0
    Sale.last.pending_amount.to_i.should eq 46
    page.should have_content("Pending: $46.00")
    click_on('Credit Card')
    within('#payment-modal') do
      find_field("payment_amount").value.should == ''
      fill_in("payment_amount", :with => 46)
      click_on('add-payment-amount')
    end
    page.should have_content("Payment matches total amount")

    # Complete the sale
    click_on('complete-sale-button')
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")
    # Check that the amount in stock has been reduced
    @product1.amount.should eq 9
    @product2.amount.should eq 8
    
    # Goes to the sale and prints an invoice
    click_on('new-successful-sale')
    click_on('print-invoice')
    fill_in 'sale[client_name]', :with => 'Jon Gutierrez'
    fill_in 'sale[tax_number]', :with => '22222222A'
    fill_in 'sale[address]', :with => 'Uribitarte 22'
    fill_in 'sale[zip_code]', :with => '48001'
    fill_in 'sale[city]', :with => 'Bilbao'
    page.find('input.button.submit-button').click
  end

  scenario 'Admin makes a day sale' do
    login
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => @product1.barcode)
      click_button('add-product-by-barcode')
    end
    page.should have_css('tr.line:nth-child(1)')
    page.find('tr.line:nth-child(1)').should have_content(@product1.name)
    page.should have_content('$15.00')

    # Clicks on 'day sale', but after that adds more products and discounts and the button should remain pushed
    within '#add-product-form' do
      fill_in('barcode', :with => @product2.barcode)
      click_button('add-product-by-barcode')
    end
    page.should have_css('tr.line:nth-child(2)')
    page.should have_content('$31.00')
    page.find('#day_sale_button').click

    # ... create a payment
    click_on('Credit Card')
    within('#payment-modal') do
      find_field("payment_amount").value.should == ''
      fill_in("payment_amount", :with => 31)
      click_on('add-payment-amount')
    end

    # ...and completes the sale
    click_on('complete-sale-button')
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")
    click_on('new-successful-sale')
    page.should_not have_content('Payments')

    # Goes to the pending day_sales view
    click_on('Administration')
    click_on('Sales')
    page.should have_css('.label.label-important')
    click_on('There are 1 day(s) with pending day sales to be checked')
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => @product1.barcode)
      click_button('add-product-by-barcode')
    end
    page.should have_css('tr.line:nth-child(1)')
    page.find('tr.line:nth-child(1)').should have_content(@product1.name)
    page.should have_content('$15.00')

    # ... create a payment
    click_on('Credit Card')
    within('#payment-modal') do
      find_field("payment_amount").value.should == ''
      fill_in("payment_amount", :with => 15)
      click_on('add-payment-amount')
    end

    # Clicks on 'day sale' and completes the sale
    page.find('#day_sale_button').click
    click_on('complete-sale-button')
    page.should have_content("The sale #{Sale.last.id - 1} has been completed successfully")
    Sale.complete.last.update_attribute(:completed_at, Date.today + 10.days)

    # Goes to the pending day_sales view
    click_on('Administration')
    click_on('Sales')
    page.should have_css('.label.label-important')
    click_on('There are 2 day(s) with pending day sales to be checked')

    # Can see all the 'day_sales' of a specific day
    click_link('2012-12-15')
    page.should have_content(Date.today.strftime('%Y-%m-%d'))
    page.should have_css('tr.sale', :count => 1)

    # Can delete pending 'day sales' on 'day_sales index'
    click_on ('Back to pending day sales')
    page.find('tr.sale:nth-child(1)').should have_content(Sale.first.created_at.to_date.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("31")
    page.find('tr.sale:nth-child(1) td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.find('tr.sale:nth-child(1)').should have_content(Sale.first.completed_at.to_date.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("15")
    page.find('tr.sale:nth-child(1) td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should have_content('No pending day sales to be checked')
  end

end
