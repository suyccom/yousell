# encoding: UTF-8

require 'spec_helper'

feature 'The admin wants to manage variations', :driver => :selenium do

  scenario 'Admin adds and edits (no conditions to edit by now) variations' do
    # The user goes to the variations index and sees it empty
    Variation.delete_all
    login
    visit '/variations'
    page.should_not have_css('tr.variation')
    # The user can add a new variation, return to the index page and see it in the list
    click_on 'New Variation'
    fill_in 'variation[name]', :with => 'Tamaño'
    click_on '+'
    click_on '+'
    click_on '+'
    fill_in 'variation[variation_values][0][name]', :with => 'pequeña'
    fill_in 'variation[variation_values][1][name]', :with => 'mediana'
    fill_in 'variation[variation_values][2][name]', :with => 'grande'
    click_on 'Create Variation'
    page.find('tr.variation:nth-child(1) .this-view').should have_content 'Tamaño'
    page.find('tr.variation:nth-child(1) .value-view').should have_content 'pequeña,mediana,grande'
    # The user can edit a variation (no conditions by now)
    page.find('tr.variation:nth-child(1) .icon-edit').click
    fill_in 'variation[name]', :with => 'Ingredientes'
    fill_in 'variation[variation_values][0][name]', :with => 'avena'
    fill_in 'variation[variation_values][1][name]', :with => 'maiz'
    fill_in 'variation[variation_values][2][name]', :with => 'trigo'
    click_on 'Save Variation'
    page.find('tr.variation:nth-child(1) .this-view').should have_content 'Ingredientes'
    page.find('tr.variation:nth-child(1) .value-view').should have_content 'avena,maiz,trigo'
    # The user can add another variation
    click_on 'New Variation'
    fill_in 'variation[name]', :with => 'Color'
    click_on '+'
    click_on '+'
    fill_in 'variation[variation_values][0][name]', :with => 'tostado'
    fill_in 'variation[variation_values][1][name]', :with => 'claro'
    click_on 'Create Variation'
    page.should have_css("tr.variation", :count => 2)
    page.find('tr.variation:nth-child(2) .this-view').should have_content 'Color'
    page.find('tr.variation:nth-child(2) .value-view').should have_content 'tostado,claro'
    # The user can't delete a variation if it's been being used on a product_type_variation
    pending("We can't test variation deletion until the application has stock")
  end

end
