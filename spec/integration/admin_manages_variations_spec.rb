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
    page.find('tr.variation:nth-child(1) .value-view').should have_content 'Without variation,grande,mediana,pequeña'
    # The user can edit a variation (no conditions by now)
    page.find('tr.variation:nth-child(1) .icon-edit').click
    fill_in 'variation[name]', :with => 'Ingredientes'
    fill_in 'variation[variation_values][1][name]', :with => 'avena'
    fill_in 'variation[variation_values][2][name]', :with => 'maiz'
    fill_in 'variation[variation_values][3][name]', :with => 'trigo'
    click_on 'Save Variation'
    page.find('tr.variation:nth-child(1) .this-view').should have_content 'Ingredientes'
    page.find('tr.variation:nth-child(1) .value-view').should have_content 'Without variation,avena,maiz,trigo'
    # The user can add another variation
    click_on 'New Variation'
    fill_in 'variation[name]', :with => 'Aspecto'
    click_on '+'
    click_on '+'
    fill_in 'variation[variation_values][0][name]', :with => 'tostado'
    fill_in 'variation[variation_values][0][code]', :with => 'TOS'
    fill_in 'variation[variation_values][1][name]', :with => 'claro'
    click_on 'Create Variation'
    page.should have_css("tr.variation", :count => 2)
    page.find('tr.variation:nth-child(2) .this-view').should have_content 'Aspecto'
    page.find('tr.variation:nth-child(2) .value-view').should have_content 'Without variation,claro,tostado'
    
    
    
    # The user can't delete a variation if it's been being used on a product_type_variation
    Variation.delete_all
    User.current_user = User.last
    size = Variation.create(:name => "Talla")
    size.variation_values << VariationValue.new(:name => "35", :code => "35")
    size.variation_values << VariationValue.new(:name => "36", :code => "36")
    size.variation_values << VariationValue.new(:name => "37", :code => "37")
    size.save
    color = Variation.create(:name => "Color")
    color.variation_values << VariationValue.new(:name => "red", :code => "RED")
    color.variation_values << VariationValue.new(:name => "blue", :code => "BLU")
    color.variation_values << VariationValue.new(:name => "green", :code => "GRE")
    color.save
    type = Variation.create(:name => "Tipo")
    type.variation_values << VariationValue.new(:name => "woman", :code => "W")
    type.variation_values << VariationValue.new(:name => "man", :code => "M")
    type.save
    visit '/variations'
    page.should have_css("tr.variation:nth-child(2) .icon-trash")
    product = FactoryGirl.build(:product)
    product.product_variations << ProductVariation.new(
      :variation => Variation.find_by_name('Color'), :value => 'blue')
    product.save
    visit '/variations'
    page.should_not have_css("tr.variation:nth-child(2) .icon-trash")
  end

end
