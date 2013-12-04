class LinesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def create
    if params[:barcode] && !params[:barcode].blank?
      product = Product.find_by_barcode(params[:barcode])
    elsif params[:products_id] && !params[:products_id].blank?
      product = Product.find(params[:products_id].first) if params[:products_id].size == 1
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
    @line = Line.find(params[:id])
    # If there is only one unit, destroy the line!
    params[:line] ||= {}
    if params[:minus]
      params[:line][:amount] = @line.amount - 1
    elsif params[:sum]
      params[:line][:amount] = @line.amount + 1
    end
    if params[:destroy]
      @line.destroy
      hobo_ajax_response
    else
      hobo_update
    end
  end

end
