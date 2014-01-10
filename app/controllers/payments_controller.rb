class PaymentsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def at_sale
    # Destroy payments of a payment method if seller passes no amount
    if params[:payment_amount] && params[:payment_amount].empty?
      Sale.find(params[:payment_sale_id]).payments.where(:payment_method_id => params[:payment_method_id]).destroy_all
    else
      # Destroy previous payments of a payment method (if any)
      prev_payments = Sale.find(params[:payment_sale_id]).payments.where(:payment_method_id => params[:payment_method_id])
      if prev_payments.count > 0
        prev_payments.destroy_all
      end
      if (params[:payment_voucher] && !params[:payment_voucher].blank? ) || params[:payment_amount]
        @payment = Payment.new(
          :sale_id => params[:payment_sale_id],
          :amount => params[:payment_voucher].blank? ? params[:payment_amount] : Voucher.find(params[:payment_voucher]).amount,
          :payment_method_id => params[:payment_method_id]
        )
        @payment.save
      end
    end
    @sale = Sale.find(params[:payment_sale_id])

    hobo_ajax_response if request.xhr?
  end

end
