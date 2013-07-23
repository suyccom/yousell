# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to make a sell', :driver => :selenium do

  before do
    # Create a product type and a couple of variations
    size = Variation.create(:name => "Size", :value => "35,36,37")
    color = Variation.create(:name => "Color", :value => "black,white,red,blue,green")
    pt = ProductType.new(:name => "Shoes", :default_price => 10)
    pt.variations << size
    pt.variations << color
    pt.save
    black_shoes = Product.new(:price => 15, :amount => 10, :barcode => '11BLACK', :product_type => pt)
    black_shoes.product_variations << ProductVariation.new(:variation => size, :value => 35)
    black_shoes.product_variations << ProductVariation.new(:variation => color, :value => 'black')
    black_shoes.save
    white_shoes = Product.new(:price => 16, :amount => 10, :barcode => '11WHITE', :product_type => pt)
    white_shoes.product_variations << ProductVariation.new(:variation => size, :value => 35)
    white_shoes.product_variations << ProductVariation.new(:variation => color, :value => 'white')
    white_shoes.save
  end

  scenario 'Admin makes a sell' do
    login
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => '11BLACK')
      click_on('+')
    end
    page.should have_css 'tr.line:nth-child(1)'
    page.find('tr.line:nth-child(1)').should have_content 'Shoes 35 black'
    page.should have_content 'Total: $15.00'

    # Adds another product
    within '#add-product-form' do
      fill_in('barcode', :with => '')
      fill_in('search', :with => 'Shoes')
      click_on('Shoes 35 white')
      click_on('+')
    end
    #page.should have_css 'tr.line:nth-child(2)'
    page.find('tr.line:nth-child(2)').should have_content 'Shoes 35 white'
    page.should have_content('Total: $31.00')

    # Adds another pair of white shoes
    within 'tr.line:nth-child(2)' do
      click_on('+')
    end
    page.should have_content('Total: $47.00')

    # Adds an incorrect barcode
    fill_in('search', :with => '')
    fill_in('barcode', :with => '11GREEN')
    click_on('+')
    page.driver.browser.switch_to.alert.accept # Accept the error dialog

    click_on('Complete Sale')
    page.should have_content('The sale has been completed successfully')
  end

  scenario 'Admin makes a day sale' do
    login
    click_on('Sell')
    page.should_not have_css('tr.line')

    # Adds a product
    within '#add-product-form' do
      fill_in('barcode', :with => '11BLACK')
      click_on('+')
    end
    page.should have_css('tr.line:nth-child(1)')
    page.find('tr.line:nth-child(1)').should have_content('Shoes 35 black')
    page.should have_content('Total: $15.00')

    # Clicks on 'day sale' and completes the sale
    find(:css, '#day_sale_button').click
    click_on('Complete Sale')
    page.should have_content('The sale has been completed successfully')
    
    # Can sees/deletes pending 'day sales'
    click_on('Administration')
    click_on('Sales')
    find(:css,'.label.label-important').set(true)
    click_on('There are pending day sales: 1')
    page.should have_css('tr.sale:nth-child(1)')
    page.find('tr.sale:nth-child(1)').should have_content(Date.today.strftime('%Y-%m-%d'))
    page.find('tr.sale:nth-child(1)').should have_content("15")
    page.find('td.controls a i.icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should have_content('No pending day sales')

  end

end
