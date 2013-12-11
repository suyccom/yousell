class WarehousesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show


  def index
    @products = Product.all
    hobo_index
  end

  def change_amount
    for p in Product.all
      if params.include?("#{p.id}")
        unless params["#{p.id}"]["amount"].empty?
          prw =  ProductWarehouse.where("warehouse_id = ? AND product_id = ?", params["#{p.id}"]["warehouse"].to_i, p.id).first
          prw.amount && prw.amount > 0 ? prw.update_attribute(:amount,prw.amount+params["#{p.id}"]["amount"].to_i) : prw.update_attribute(:amount,params["#{p.id}"]["amount"].to_i)
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
