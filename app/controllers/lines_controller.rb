class LinesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def create
    # There's no need to use else here: Hobo will throw a validation error :)
    if product = Product.find_by_barcode(params[:barcode]) || Product.find_by_name(params[:search])
      params[:line][:product_id] = product.id
    end
    # If the sale already has the same product, just add one unit to it instead of creating a new line
    sale = Sale.find(params[:line][:sale_id])
    line = sale.lines.find{|s| s.product == product;}
    if line
      line.update_attributes(:amount => line.amount + 1)
      hobo_ajax_response
    else
      hobo_create
    end
  end
  
  def update
    line = Line.find(params[:id])
    if params[:minus]
      # If there is only one unit, destroy the line!
      if line.amount == 1
        line.destroy
      else
        line.update_attributes(:amount => line.amount - 1)
      end
    elsif params[:sum]
      line.update_attributes(:amount => line.amount + 1)
    end
    hobo_ajax_response
  end

end
