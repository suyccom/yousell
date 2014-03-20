
class SalesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def new
    @products = Product.all
    session[:active_sale_id] = params[:active_sale_id] if params[:active_sale_id]
    # If there's an active sale in the DB, load it. Else, create a new one
    if session[:active_sale_id] && Sale.not_complete.exists?(session[:active_sale_id]) 
      @sale = Sale.find(session[:active_sale_id])
    else
      @sale = Sale.create
      session[:active_sale_id] = @sale.id
    end
    hobo_new
  end

  def new_sale
    @sale = Sale.create
    session[:active_sale_id] = @sale.id
    redirect_to('/')
  end

  def update

    # This avoids the user to set '' as total discount
    params[:sale][:total_discount] = 0 if params[:sale] && params[:sale][:total_discount] && params[:sale][:total_discount].blank?
    
    if params[:payment_sale_id] && Sale.find(params[:payment_sale_id]).pending_amount > 0
      flash[:error] = I18n.t('sale.messages.pending_amount')
      redirect_to('/')
    elsif params[:payment_sale_id] && Sale.find(params[:payment_sale_id]).pending_amount < 0
      flash[:error] = I18n.t('sale.messages.pending_amount')
      redirect_to('/')
    else
      # Comprobamos si todos los productos tienen stock
      for l in Sale.find(params[:id]).lines
        if l.amount > 0
          cantidad = 0
          for w in l.product.product_warehouses
            cantidad += w.amount if w.amount
          end
          break if cantidad <= 0
        end
      end
      if cantidad && cantidad == 0
        product_id = Product.find_by_name(w.product.name).id
        flash[:error] = I18n.t('activerecord.errors.models.product.attributes.amount.stock',
                        :href => ActionController::Base.helpers.link_to("#{w.product.name}",
                        "/products/#{product_id}/edit")).html_safe
        if params[:sale][:day_sale] 
          hobo_update
        else
          hobo_ajax_response
          redirect_to ("/")
        end
      else
        hobo_update do
          if request.xhr?
            hobo_ajax_response
          elsif params[:sale][:client_name]
            redirect_to("/sales/#{@sale.id}.pdf")
          else
            Voucher.find(params[:payment_voucher]).update_attributes(:state => "canjeado", :payment_id => @sale.payments.where("payment_method_id = 3").first.id) if params[:payment_voucher] && !params[:payment_voucher].blank?
            flash[:notice] = I18n.t('sale.messages.create.success', 
                          :href => ActionController::Base.helpers.link_to("#{Sale.find(params[:id]).id}",
                          "/sales/#{Sale.find(params[:id]).id}")).html_safe
            redirect_to('/')
          end
        end
      end
    end
  end

  def index
    # Get 'day sales' grouped by completed_at date: 2 columns, date and money amount
    @day_sales_count = Sale.complete.day_sale.select("sum(sale_total) as sale_total_sum, date(completed_at) as completed_at_date").group("date(completed_at)").to_a.count
    @sales_count = Sale.not_complete.count
    unless params[:completed_at_date]
      hobo_index Sale.complete.not_day_sale
    else
      hobo_index Sale.complete.day_sale.where(['DATE(completed_at) = ?',params[:completed_at_date].to_date])
    end
  end

  def pending_day_sales
    @day_sales,@day_sales_count = calculate_day_sales_and_count
  end

  def pending_sales
    @sales,@sales_count = calculate_sales_and_count
  end

  def destroy_pending_day_sales
    if params[:sales_date]
      Sale.where(:completed_at => params[:sales_date].to_date.beginning_of_day..params[:sales_date].to_date.end_of_day).complete.day_sale.destroy_all
      @day_sales,@day_sales_count = calculate_day_sales_and_count
      redirect_to('/pending_day_sales')
    end
  end

  def destroy_pending_sales
    if params[:sales_id]
      Sale.find(params[:sales_id]).destroy
    end 
    @day_sales,@day_sales_count = calculate_day_sales_and_count
    redirect_to('/pending_sales')
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
    @voucher = Voucher.where("payment_id = ?",Payment.where("sale_id = ? AND payment_method_id = ?", params[:id],PaymentMethod.where("voucher = 't'").first.id).first.id).first if Sale.find(params[:id]).payments.*.payment_method.*.voucher.include?("true")
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

  def calculate_sales_and_count
    sales = Sale.not_complete
    sales_count = sales.count
    return sales,sales_count
  end

end
