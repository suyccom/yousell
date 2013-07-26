class LinesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def create
    if params[:barcode] && !params[:barcode].blank?
      product = Product.find_by_barcode(params[:barcode])
    elsif params[:search] && !params[:search].blank?
      product = Product.find_by_name(params[:search])
    end # There's no need to use else here: Hobo will throw a validation error :)
    params[:line][:product_id] = product.id if product
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
    elsif params[:amount]
      line.update_attributes(:amount => params[:amount].to_i)
    end
    if params[:discount]
      line.update_attributes(:discount => "#{params[:discount]}")
    end
    if params[:type_discount]
      line.update_attributes(:type_discount => "#{params[:type_discount]}")
    end
    hobo_ajax_response
  end

end
