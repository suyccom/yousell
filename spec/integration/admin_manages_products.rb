# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage products', :driver => :selenium do

  scenario 'Admin adds, removes and edits products' do
    # The user goes to the products index and sees it empty
    login
    click_on('Almacén')
    page.should_not have_css('tr.products')
  end

end
