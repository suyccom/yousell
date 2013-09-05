require 'spec_helper'

feature 'The admin manages vouchers:', :driver => :selenium do

  before do
    User.current_user = User.last
    login
  end

  scenario 'an admin adds 2 vouchers, deletes one, and edits the last one' do
    # The admin goes to vouchers index
    click_on('Administration')
    click_on('Vouchers')
    # There is no voucher active
    page.should have_content('No records to display')
    # Clicks on new and adds a voucher
    click_on('New Voucher')
    fill_in('voucher[validity_period]',:with => '30/04/2014')
    fill_in('voucher[amount]',:with => '100')
    click_on('Create Voucher')
    page.should have_content("Voucher #{Voucher.last.id}")
    # Repeats the operation and now the index has 2 vouchers
    click_on('New Voucher')
    fill_in('voucher[validity_period]',:with => '30/04/2014')
    fill_in('voucher[amount]',:with => '100')
    click_on('Create Voucher')
    page.should have_content("Voucher #{Voucher.last.id}")
    # The admin clicks on delete icon (index) and the index just shows one voucher
    page.find('tr.voucher:nth-child(1) .icon-trash').click
    page.driver.browser.switch_to.alert.accept
    page.should_not have_content("Voucher #{Voucher.last.id}")
    # The admin clicks on edit icon and then the admin changes the amount of voucher
    page.find('tr.voucher:nth-child(1) .icon-edit').click
    fill_in('voucher[amount]',:with => '1000')
    click_on('Save')
    page.should have_content('1,000.0')
  end

end
