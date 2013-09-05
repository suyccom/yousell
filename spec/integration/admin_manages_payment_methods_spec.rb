# encoding: UTF-8

require 'spec_helper'

feature 'The admin manages different kinds of payment methods:', :driver => :selenium do

  before do
    PaymentMethod.delete_all # We need to empty this table to avoid collisions with admin_makes_a_sale_spec.rb
    User.current_user = User.last
    login
  end

  scenario 'an admin adds 2 payment methods, deletes one, and edits the last one' do
    # The admin goes to payment methods index
    click_on('Administration')
    click_on('Payment methods')
    # There is no payment method active
    page.should have_content('No Payment methods, please add some')
    # Clicks on new and adds a payment method
    click_on('New Payment method')
    fill_in('payment_method[name]',:with => 'Credit card')
    click_on('Create Payment method')
    page.should have_content('Credit card')
    # Repeats the operation and now the index has 2 payment methods
    click_on('New Payment method')
    fill_in('payment_method[name]',:with => 'Cash')
    click_on('Create Payment method')
    page.should have_content('Cash')
    # The admin clicks on delete icon (index) and the index just shows one payment method
    page.find('tr.payment_method:nth-child(1) .icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should_not have_content('Credit card')
    # The admin clicks on edit icon and then the admin changes the name of payment method
    page.find('tr.payment_method:nth-child(1) .icon-edit').click
    fill_in('payment_method[name]',:with => 'Check')
    click_on('Save')
    page.should have_content('Check')
    # The admin can't add a payment method with the same name of an existant payment method
    click_on('New Payment method')
    fill_in('payment_method[name]',:with => 'Check')
    click_on('Create Payment method')
    page.should have_content('Name has already been taken')
  end

end
