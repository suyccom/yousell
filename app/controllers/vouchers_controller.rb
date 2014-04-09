class VouchersController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

  def create
    if request.xhr?
      @sale = Sale.find(params[:voucher][:sale_id])
      Voucher.create(:amount => @sale.pending_amount.abs, :sale_id => @sale.id)
      hobo_ajax_response
    else
      hobo_create
    end
  end

  def index
    if params[:print]
      @voucher = Voucher.find(params[:id])
      render :pdf => I18n.t('activerecord.attributes.voucher.Voucher'), 
        :show_as_html => params[:debug].present?, 
        :encoding => 'UTF-8',
        :disable_javascript => true,
        :use_xserver => false,
        :template => 'vouchers/voucher.pdf.dryml'
    else
      hobo_index Voucher.apply_scopes(
      :state_is => params[:state],
    ), :per_page => params[:per_page] ? params[:per_page].to_i : 15
    end
  end
end
