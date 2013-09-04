class VouchersController < ApplicationController

  hobo_model_controller

  auto_actions :all



  def create
    hobo_create do
      redirect_to "/vouchers"
    end
  end

end
