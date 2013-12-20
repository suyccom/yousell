class VouchersController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

  def index
      hobo_index Voucher.apply_scopes(
      :state_is => params[:state],
    ), :per_page => params[:per_page] ? params[:per_page].to_i : 15
  end

end
