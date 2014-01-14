class ProductsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :create]

  autocomplete

  def generate_labels(empty_cells, products, labelsheet)
    require 'barby'
    require 'barby/barcode/code_93'
    require 'barby/outputter/png_outputter'
    require 'prawn'
    require 'prawn/labels'

    printer_margin = 11.91 # FIXME: this data should not be hardcoded

    Prawn::Labels.types = {
      labelsheet.name => {
        "paper_size"    => "A4",
        "columns"       => labelsheet.columns,
        "rows"          => labelsheet.rows,
        "top_margin"    => labelsheet.top_margin,
        "bottom_margin" => labelsheet.bottom_margin,
        "left_margin"   => labelsheet.left_margin,
        "right_margin"  => labelsheet.right_margin
      }
    }

    # Create the array for the labels PDF
    barcodes = []
    pngs = []
    textos_barcodes = []
    textos_resto = []

    params[:empty_cells].to_i.times do
      barcodes << {}
      pngs << ''
      textos_barcodes << ''
      textos_resto << ''
    end

    # Calculate cell width
    logger.info('txapelgorri ancho tipo documento: ' + Prawn::Document::PageGeometry::SIZES["A4"][0].to_s)
    logger.info('txapelgorri alto tipo documento: ' + Prawn::Document::PageGeometry::SIZES["A4"][1].to_s)
    logger.info('txapelgorri correccion de la impresora: 0.42mm a cada lado (11.91px a cada lado). El margen que mete la impresora no deve afectar al tamaño de la celda. Solamente al tamaño del papel.')
    cell_width = (Prawn::Document::PageGeometry::SIZES['A4'][0] - ((labelsheet.left_margin - printer_margin) + (labelsheet.right_margin - printer_margin)))/labelsheet.columns
    logger.info('txapelgorri ancho celda : ' + cell_width.to_s)

    for product in products
      # Create the barcode PNGs
      temp_png = "#{Rails.root}/tmp/barcode-#{product[0].id}.png"
      barby = Barby::Code93.new(product[0].barcode)
      png = Barby::PngOutputter.new(barby)
      logger.info('txapelgorri - barby_full_width: ' + png.full_width.to_s)
      logger.info('txapelgorri - factor xdim: ' + (cell_width/png.full_width).round(2).to_s)
      xdim_correction = (cell_width/png.full_width).round(2)
      png = png.to_png(:height => 35, :margin => 5, :xdim => 1)
      File.open(temp_png, 'w'){|f| f.write png }
      # Add the label to the barcodes array
      product[1].to_i.times do
        pngs << temp_png
        textos_barcodes << product[0].barcode
        textos_resto << "\n" + product[0].name  + " " + product[0].description # FIXME: until we achieve another solution, description remain hidden, because adding the description breaks the label generation (too much text).
      end
    end

    # Generate the PDF
    temp_pdf = "#{Rails.root}/tmp/labels.pdf"
    labels = Prawn::Labels.generate(temp_pdf, textos_barcodes, :type => labelsheet.name, :shrink_to_fit => true) do |pdf,texto_barcode|
      unless texto_barcode.blank?
        pdf.image pngs[textos_barcodes.index(texto_barcode)], :width => cell_width
        pdf.text  texto_barcode, :size => 9
        pdf.text  textos_resto[textos_barcodes.index(texto_barcode)], :size => 7
      end
    end

    # Print or send the PDF back to the browser
    if defined? PRINT_LABELS_COMMAND
      system("#{PRINT_LABELS_COMMAND} #{temp_pdf}")
      flash[:info] = I18n.t("product.show.labels_sent_to_printer")
      redirect_to '/products'
    else
      send_file temp_pdf, :type => "application/pdf", :disposition => "inline"
    end

  end

  def product_labels
    product = Product.find(params[:id])
    products = [[ product, params[:number] ]]
    labelsheet = Labelsheet.find(params[:labelsheet_id])
    generate_labels(params[:empty_cells], products, labelsheet)
  end

  def last_products_labels
    products = User.current_user.last_added_products.map{|p| [Product.find(p[0]), p[1]] }
    labelsheet = Labelsheet.find(params[:labelsheet_id])
    generate_labels(params[:empty_cells], products, labelsheet)
  end

  def index
    if params[:last_added]
      products = Product.where(:id => User.current_user.last_added_products.map{|p| p[0]})
    else
      products = Product.apply_scopes(:order_by => parse_sort_param(:name))
    end
    variaciones = []
    for v in Variation.all
      variaciones << params[v.name.downcase] if params[v.name.downcase] && params[v.name.downcase] != ""
    end
    hobo_index products.apply_scopes(
      :name_contains => params[:name],
      :description_contains => params[:description],
      :variaciones => variaciones.join(",")
    ), :per_page => params[:per_page] ? params[:per_page].to_i : 15
  end
  
  def multiple_changes
    # Delete products selected
    if params[:delete] && params[:delete] == "true" && params[:product_check] && !params[:product_check].empty?
      for product in Product.find(params[:product_check])
        product.destroy
      end
      flash[:info] = I18n.t("product.show.products_removed")
    # Transfer products selected
    elsif params[:price] && params[:price].to_i == 0 && params[:to] && params[:from] && !params[:to].empty? && !params[:from].empty? && params[:product_check] && !params[:product_check].empty?
      from = Warehouse.find_by_name(params[:from]).id
      to = Warehouse.find_by_name(params[:to]).id
      for p in params[:product_check]
        init_pr = ProductWarehouse.where('warehouse_id = ?',from).where('product_id = ?', Product.find(p))
        end_pr = ProductWarehouse.where('warehouse_id = ?',to).where('product_id = ?', Product.find(p))
        if !init_pr.empty? && !init_pr.first.amount.blank? && !end_pr.empty? && !end_pr.first.amount.blank?
          # Rest one to the quantity of product in the warehouse indicated
          init_pr.first.update_attribute(:amount, init_pr.first.amount - 1) if init_pr.first.amount > 0
          # I'm adding to the amount of product in stock destination
          end_pr.first.update_attribute(:amount, end_pr.first.amount + 1)
          flash[:info] = I18n.t("product.show.products_transfered")
        end
      end
    # Change price 
    elsif params[:price] && params[:price].to_i > 0 && params[:product_check] && !params[:product_check].empty?
      for product in Product.find(params[:product_check])
        product.update_attribute(:price, params[:price])
      end
      flash[:info] = I18n.t("product.show.prices_changed")
    end
    redirect_to '/products'
  end

  def update
    if request.xhr?
      hobo_ajax_response
    else
      hobo_update
    end
  end
end
