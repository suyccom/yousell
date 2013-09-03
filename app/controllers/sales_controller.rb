
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
      flash[:notice] = I18n.t("sale.messages.create.success", 
      :href => ActionController::Base.helpers.link_to("#{Sale.find(params[:id]).id}",
               "/sales/#{Sale.find(params[:id]).id}")).html_safe
      if request.xhr?
        hobo_ajax_response
      elsif params[:sale][:client_name]
        redirect_to "/sales/#{@sale.id}.pdf"
      else
        redirect_to '/'
      end
    end
  end

  def index
    # Get 'day sales' grouped by completed_at date: 2 columns, date and money amount
    @day_sales_count = Sale.complete.day_sale.select("sum(sale_total) as sale_total_sum, date(completed_at) as completed_at_date").group("date(completed_at)").to_a.count
    unless params[:completed_at_date]
      hobo_index Sale.complete.not_day_sale
    else
      hobo_index Sale.complete.day_sale.where(:created_at == params[:completed_at_date].to_date)
    end
  end

  def pending_day_sales
    @day_sales,@day_sales_count = calculate_day_sales_and_count
  end

  def destroy_pending_day_sales
    if params[:sales_date]
      Sale.where(:completed_at => params[:sales_date].to_date.beginning_of_day..params[:sales_date].to_date.end_of_day).complete.day_sale.destroy_all
      @day_sales,@day_sales_count = calculate_day_sales_and_count
      redirect_to('/pending_day_sales')
    end
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

  def show
    hobo_show do
      if request.format.pdf?
        if params[:ticket]
          render :pdf => I18n.t('sale.show.ticket'), 
            :show_as_html => params[:debug].present?, 
            :encoding => 'UTF-8',
            :disable_javascript => true,
            :use_xserver => true,
            :template => 'sales/ticket.pdf.dryml'
        else
          render :pdf => I18n.t('sale.show.invoice'), 
            :show_as_html => params[:debug].present?, 
            :encoding => 'UTF-8',
            :disable_javascript => true,
            :use_xserver => true
        end
      end
    end
  end

  private

  def calculate_day_sales_and_count
    day_sales = Sale.complete.day_sale.select("sum(sale_total) as sale_total_sum, count(*) as sale_number, date(completed_at) as completed_at_date").group("date(completed_at)")
    day_sales_count = day_sales.to_a.count
    return day_sales,day_sales_count
  end

end
