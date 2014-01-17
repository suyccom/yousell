class WarehousesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show


  def index
    @products = Product.all
    hobo_index
  end

  def change_amount
    for w in Warehouse.all
      for param in params 
        if param.include?("#{w.id}")
          prw = ProductWarehouse.where("warehouse_id = ? AND product_id = ?", w.id, param.last.first.first.to_i).first
          prw.amount && prw.amount > 0 ? prw.update_attribute(:amount,prw.amount+param.last.first.last.to_i) : prw.update_attribute(:amount,param.last.first.last.to_i)
        end
      end
    end
    flash[:message] = "Las cantidades han sido actualizadas"
    redirect_to '/warehouses'
  end

  def refill_lines
    @selected_products = []
    if params[:destroy] == "true"
      params[:products_id] = params[:clon_lines].gsub(/\s+/, "").delete("[").delete("]").split(",").reject { |id| id == params[:product_id] }
    else
      unless params[:clon_lines].blank?
        # Esto se podra mejorar con una expresión regular
        for p in params[:clon_lines].delete("[").delete("]").split(",")
          params[:products_id] << p
        end
      end
    end
    for p in params[:products_id].uniq
      @selected_products << Product.find(p)
    end
    hobo_ajax_response
  end

end
