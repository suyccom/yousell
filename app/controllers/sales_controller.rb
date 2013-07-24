class SalesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :edit
  
  def new
    # If there's an incomplete sale in the DB, load it. Else, create a new one
    @sale = Sale.not_complete.count > 0 ? Sale.not_complete.last : Sale.create
    hobo_new
  end
  
  def update
    if params[:total_discount] && request.xhr?
      sale = Sale.find(params[:id])
      sale.update_attributes(:total_discount => params[:total_discount])
      sale.update_attributes(:type_discount => params[:type_discount])
      hobo_ajax_response
    else
      hobo_update do
        flash[:notice] = I18n.t("sale.messages.create.success")
        redirect_to '/'
      end
    end
  end
  
  def index
    hobo_index Sale.complete
  end
  
  def cancel
    @sale = Sale.find(params[:id])
    @new_sale = @sale.dup
    @new_sale.refunded_ticket = @sale
    @new_sale.complete = false # Sales cannot be saved if they are complete and have no lines
    @new_sale.save
    for line in @sale.lines
      Line.create(:sale => @new_sale, :product => line.product, :amount => line.amount)
    end
    @new_sale.update_attribute(:complete, true) # Now we "complete" it again :)
    redirect_to @new_sale
  end
  
end
