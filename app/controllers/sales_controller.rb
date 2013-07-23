class SalesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :edit

  def new
    # If there's an incomplete sale in the DB, load it. Else, create a new one
    @sale = Sale.not_complete.count > 0 ? Sale.not_complete.last : Sale.create
    hobo_new
  end

  def update
    hobo_update do
      flash[:notice] = I18n.t("sale.messages.create.success")
      redirect_to '/'
    end
  end

  def index
    # Get 'day sales' grouped by completed_at date: 2 columns, date and money amount
    @day_sales_count = Sale.complete.day_sale.select("sum(sale_total) as sale_total_sum, date(completed_at) as completed_at_date").group("date(completed_at)").to_a.count
    hobo_index Sale.complete.not_day_sale
  end

  def pending_day_sales
    @day_sales,@day_sales_count = calculate_day_sales_and_count
  end
  
  def destroy_pending_day_sales
    if params[:sales_date]
      Sale.where(:completed_at => params[:sales_date].to_date.beginning_of_day..params[:sales_date].to_date.end_of_day).complete.day_sale.destroy_all
      @day_sales,@day_sales_count = calculate_day_sales_and_count
      hobo_ajax_response if request.xhr?
    end
  end

  private

  def calculate_day_sales_and_count
    day_sales = Sale.complete.day_sale.select("sum(sale_total) as sale_total_sum, date(completed_at) as completed_at_date").group("date(completed_at)")
    day_sales_count = day_sales.to_a.count
    return day_sales,day_sales_count
  end

end