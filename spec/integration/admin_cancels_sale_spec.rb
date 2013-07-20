# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to cancel a sale', :driver => :selenium do

  before do
    @sale = FactoryGirl.create(:sale)
    login
  end

  scenario 'cancels a sale and a refund ticket is created' do
    visit '/sales'
    page.find('tr.sale:nth-child(1) .total-view').text.should eq '$10.00'
    click_on @sale.name
    click_on 'Cancel' 
    page.driver.browser.switch_to.alert.accept # Works with Selenium driver
    page.should have_content '-$10.00'
    visit '/sales'
    page.find('tr.sale:nth-child(2) .this-view').text.should eq "Refund ticket #{@sale.id}"
    page.find('tr.sale:nth-child(2) .total-view').text.should eq '-$10.00'
  end

end

