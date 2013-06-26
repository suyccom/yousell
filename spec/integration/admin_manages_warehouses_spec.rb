# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage warehouses', :driver => :selenium do

  scenario 'Admin adds and edits warehouses' do
    # The user goes to the warehouses index and sees it empty
    login
    visit '/warehouses'
    page.should_not have_css('tr.warehouse')
    # The user can add a new warehouse, return to the index page and see it in the list
    click_on 'New Warehouse'
    fill_in 'warehouse[name]', :with => 'Uribitarte 8'
    click_on 'Create Warehouse'
    page.find('tr.warehouse:nth-child(1) .this-view').should have_content 'Uribitarte 8'
    # The user can edit a warehouse
    page.find('tr.warehouse:nth-child(1) .icon-edit').click
    fill_in 'warehouse[name]', :with => 'Uribitarte 18'
    click_on 'Save Warehouse'
    page.find('tr.warehouse:nth-child(1) .this-view').should have_content 'Uribitarte 18'
    # The user can add another warehouse
    click_on 'New Warehouse'
    fill_in 'warehouse[name]', :with => 'Elkano 3'
    click_on 'Create Warehouse'
    visit '/warehouses'
    page.should have_css("tr.warehouse", :count => 2)
    page.find('tr.warehouse:nth-child(2) .this-view').should have_content 'Elkano 3'
  end

  scenario 'The user can delete warehouses only when they are empty' do
    # The user can destroy a warehouse, and the system forces him to move the stock to another warehouse
    # The user can't destroy the only remaining warehouse (he can only destroy if there is no product in it)
    pending("We can't test this until the application has stock")
  end

end
