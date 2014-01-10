class VouchersController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

  def index
    if params[:print]
      @voucher = Voucher.find(params[:id])
      render :pdf => I18n.t('activerecord.attributes.voucher.Voucher'), 
        :show_as_html => params[:debug].present?, 
        :encoding => 'UTF-8',
        :disable_javascript => true,
        :use_xserver => true,
        :template => 'vouchers/voucher.pdf.dryml'
    else
      hobo_index Voucher.apply_scopes(
      :state_is => params[:state],
    ), :per_page => params[:per_page] ? params[:per_page].to_i : 15
    end
  end
end
