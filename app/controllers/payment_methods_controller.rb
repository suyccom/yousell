class PaymentMethodsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show


  def update
    if params[:payment_method] && params[:payment_method][:voucher].to_i > 0
      for pm in PaymentMethod.all
        pm.update_attribute(:voucher, false)
      end
    end
    hobo_update
  end

end
