class ProductTypesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

  include ActionView::Helpers::JavaScriptHelper

  autocomplete

  def create
    # First of all, clear the last_added_products field
    current_user.update_attribute(:last_added_products, [])
    @product_type = ProductType.new(params[:product_type])
    for product in @product_type.products
      unless product.code.blank?
        pt = ProductType.find_by_name(product.code)
        unless pt
          pt = ProductType.create!(:name => product.code)
        end
        product.product_type = pt
        product.save!
      end
    end
    redirect_to '/products?last_added=true'
  end

  def transfer
    @products = Product.all
    @warehouse = Warehouse.all
    if params[:products_transfer] && !params[:products_transfer].empty?
      from = Warehouse.find_by_name(params[:from]).id
      to = Warehouse.find_by_name(params[:to]).id
      for b in params[:products_transfer].gsub("\r\n", ",").split(',')
        
        # Rest one to the quantity of product in the warehouse indicated
        init_pr = ProductWarehouse.where('warehouse_id = ?',from).where('product_id = ?', Product.find_by_barcode(b))
        init_pr.first.update_attribute(:amount, init_pr.first.amount - 1)
        # I'm adding to the amount of product in stock destination
        end_pr = ProductWarehouse.where('warehouse_id = ?',to).where('product_id = ?', Product.find_by_barcode(b))
        end_pr.first.update_attribute(:amount, end_pr.first.amount + 1)
        flash[:message] = "Se han cambiado los productos de almacen"
      end
    end
  end

  def new_from_barcode
    @variations = {}
    @position = 0
    for piece in BARCODE_FORMAT
      parse_piece(params[:barcode], piece[:type], piece[:chars], piece[:name])
    end

    linea = escape_javascript(render_to_string)
    render :js => "$('#{linea}').hide().appendTo('#products-table').fadeIn(250); $('#barcode').val('').focus()"
  end

  def rellenar_textarea
        logger.info "esto es textarea #{@textarea}"
        logger.info "esto es products #{params[:products_id]}"
    for p in params[:products_id]
        logger.info "esto entra por for"
      if @textarea.blank?
        @textarea = "#{Product.find(p).barcode}\n"
      else
        @textarea += "#{Product.find(p).barcode}\n"
        logger.info "esto es textarea #{@textarea}"
      end
    end
    hobo_ajax_response
#$('textarea[name=textarea-transfer]').text();
  end


  private

  def parse_piece(barcode, type, chars, name)
    string = barcode[@position, chars]
    case type
    when :provider
      provider = Provider.find_by_code(string)
      @provider = [provider.name, provider.id] if provider
    when :variation
      vv = VariationValue.find_by_code(string)
      @variations[name] = vv.name if vv
    when :code
      @code = string.to_i.to_s
    end
    @position += chars
  end

end
