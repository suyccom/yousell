# encoding: UTF-8

require 'spec_helper'

feature 'Sale stock checks', :driver => :selenium do

  before do
    @product = FactoryGirl.create(:product)
    login
  end

  scenario 'The admin can not add a product without stock' do
    @product.update_attribute(:amount, 0)
    visit '/'
    within '#add-product-form' do
      fill_in 'barcode', :with => @product.barcode
      click_on '+'
    end
    # Accept the error alert
    page.driver.browser.switch_to.alert.accept
    page.should_not have_css 'tr.line:nth-child(1)'
  end
  
  scenario 'The admin can not increase the units of a product if there is not enough stock' do
    @product.update_attribute(:amount, 2)
    visit '/'
    within '#add-product-form' do
      fill_in 'barcode', :with => @product.barcode
      click_on '+'
    end
    page.should have_content 'Total: $10.00'
    within 'tr.line:nth-child(1)' do
      click_on '+'
    end
    page.should have_content 'Total: $20.00'
    within 'tr.line:nth-child(1)' do
      click_on '+'
    end
    # Accept the error alert
    page.driver.browser.switch_to.alert.accept
    
    # The total remains the same
    page.should have_content 'Total: $20.00'
  end
  
end


# EJEMPLOS: Borrar al finalizar el test
def ejemplos
  # Navegar, hacer clics
  visit '/'
  click_on 'Facturar'
  page.find('tr.factura:nth-child(1) .icon-pencil').click
  page.driver.browser.switch_to.alert.accept # Works with Selenium driver
  
  # Formularios
  fill_in 'factura[fecha_emision]', :with => '13/12/2012'
  select 'Carlos'
  check 'expediente[esquela_foto]'
  uncheck 'expediente[esquela_foto]'
  
  # Comprobar la página
  page.should have_content 'Patata'
  page.find('tr.factura:nth-child(1) .num-factura-view').text.should eq ''
  page.find('tr.factura:nth-child(1) .descripcion-view').should have_content 'Factura del hijo'
  wait_until { page.find('tr.factura:nth-child(1) .num-factura-view').text.strip == '2012010001' }
  page.should have_css('table tbody .tipo_iva', :count => 2)
  page.should_not have_css('tr.concepto_factura:nth-child(2) .icon-trash')
  page.should have_selector("input[type=submit][value='Pagar con tarjeta / Paypal']")
end
