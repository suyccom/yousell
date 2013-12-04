class LinesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def create
    sale = Sale.find(params[:line][:sale_id])
    products = []
    lines = []

    if params[:barcode] && !params[:barcode].blank?
      products << Product.find_by_barcode(params[:barcode])
    elsif params[:products_id] && !params[:products_id].blank?
      for p in params[:products_id]
        products << Product.find(p)
      end
    end
    for product in products
      params[:line][:product_id] = product.id if product
      # If the sale already has the same product, just add one unit to it instead of creating a new line
      line = sale.lines.find{|s| s.product == product;}
      if line
        line.update_attributes(:amount => line.amount + 1)
      else
        Line.create(params[:line])
      end
    end
    hobo_ajax_response
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
