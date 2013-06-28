# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage product_types', :driver => :selenium do

  scenario 'Admin adds and edits (no conditions to edit by now) product_types' do
    # The user goes to the product_types index and sees it empty
    login
    visit '/product_types'
    page.should_not have_css('tr.product_type')
    # The user can add a new product_type, return to the index page and see it in the list
    click_on 'New Product type'
    fill_in 'product_type[name]', :with => 'Barra de pan'
    fill_in 'product_type[default_price]', :with => '1'
    click_on 'Create Product type'
    page.find('tr.product_type:nth-child(1) .name-view').should have_content 'Barra de pan'
    page.find('tr.product_type:nth-child(1) .default-price-view').should have_content '1'
    # The user can edit a product_type (no conditions by now)
    page.find('tr.product_type:nth-child(1) .icon-edit').click
    fill_in 'product_type[name]', :with => 'Barra'
    fill_in 'product_type[default_price]', :with => '1.5'
    click_on 'Save Product type'
    page.find('tr.product_type:nth-child(1) .name-view').should have_content 'Barra'
    page.find('tr.product_type:nth-child(1) .default-price-view').should have_content '1.5'
    # The user can add another product_type
    click_on 'New Product type'
    fill_in 'product_type[name]', :with => 'Pan de pueblo'
    fill_in 'product_type[default_price]', :with => '2'
    click_on 'Create Product type'
    page.should have_css("tr.product_type", :count => 2)
    page.find('tr.product_type:nth-child(2) .name-view').should have_content 'Pan de pueblo'
    page.find('tr.product_type:nth-child(2) .default-price-view').should have_content '2'
    # The user can't delete a product_type if it's been being used on a product_type_product_type
    pending("We can't test product_type deletion until the application has stock")
  end

end
