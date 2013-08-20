
class SalesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def new
    # If there's an incomplete sale in the DB, load it. Else, create a new one
    @sale = Sale.not_complete.count > 0 ? Sale.not_complete.last : Sale.create
    hobo_new
  end

  def update
    hobo_update do
      if params[:sale][:day_sale] && params[:sale][:day_sale].to_i > 0
        redirect_to('/pending_day_sales')
      elsif params[:page_path] == "/sales/#{Sale.find(params[:id]).id}/edit"
        redirect_to('/sales')
      else
        flash[:notice] = I18n.t("sale.messages.create.success", 
        :href => ActionController::Base.helpers.link_to("#{Sale.find(params[:id]).id}",
                 "/sales/#{Sale.find(params[:id]).id}")).html_safe
        request.xhr? ? hobo_ajax_response : (redirect_to '/')
      end
    end
  end

  def index
    # Get 'day sales' grouped by completed_at date: 2 columns, date and money amount
    @day_sales_count = Sale.complete.day_sale.count
    hobo_index Sale.complete.not_day_sale
  end

  def pending_day_sales
    @day_sales,@day_sales_count = calculate_day_sales_and_count
  end

  def destroy_pending_day_sales
    sale = Sale.find(params[:sales_date])
    sale.destroy
    @day_sales,@day_sales_count = calculate_day_sales_and_count
    redirect_to('/pending_day_sales')
  end

  def cancel
    @sale = Sale.find(params[:id])
    @new_sale = @sale.dup
    @new_sale.refunded_ticket = @sale
    @new_sale.sale_total = @sale.sale_total * -1
    @new_sale.complete = false # Sales cannot be saved if they are complete and have no lines
    @new_sale.save
    for line in @sale.lines
      Line.create(:sale => @new_sale, :product => line.product, :amount => line.amount)
      pw = line.product.current_product_warehouse
      pw.update_attribute(:amount, pw.amount + line.amount)
    end
    @new_sale.update_attribute(:complete, true) # Now we "complete" it again :)
    redirect_to @new_sale
  end

  private

  def calculate_day_sales_and_count
    day_sales = Sale.complete.day_sale
    day_sales_count = Sale.complete.day_sale.count
    return day_sales,day_sales_count
  end

end
