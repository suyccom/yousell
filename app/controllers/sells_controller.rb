class SellsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def new
    hobo_new do
      if params[:barcode]
        product = Product.find_by_barcode(params[:barcode])
        if product
          @sell.lines << Line.new(:product => product, :price => product.price, :name => product.name)
        else
          params[:error] = I18n.t('barcode_not_found')
        end
      end
    end
  end
  
  def create
    hobo_create
  end

end
