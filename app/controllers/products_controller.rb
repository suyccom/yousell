class ProductsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  autocomplete
  
  def new
    hobo_new do
      if @product.product_type
        @product.product_variations = []
        for v in @product.product_type.variations
          @product.product_variations << ProductVariation.new(:variation => v)
        end
      end
      if @product.provider && @product.provider_code == ''
        @product.provider_code = @product.provider.code
      end
    end
  end
  
  def print_labels
    @product = Product.find(params[:id])

    temp_file = "#{Rails.root}/tmp/barcode.png"
    temp_pdf = "#{Rails.root}/tmp/labels.pdf"
   
    # Create the barcode PNG
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'
    barby = Barby::Code128B.new(@product.barcode)
    png = Barby::PngOutputter.new(barby).to_png(:height => 20, :margin => 5)
    File.open(temp_file, 'w'){|f| f.write png }
    
    # Create the array for the labels PDF
    barcodes = []
    params[:empty_cells].to_i.times do
      barcodes << ""
    end
    params[:number].to_i.times do
      barcodes << temp_file
    end
    
    # Generate the PDF
    labels = Prawn::Labels.generate(temp_pdf, barcodes, :type => "Avery5160") do |pdf, barcode|
      unless barcode.blank?
        pdf.image barcode 
        pdf.text @product.barcode
        pdf.text @product.name
      end
    end
    
    # Print or send the PDF back to the browser
    if defined? PRINT_LABELS_COMMAND
      system("#{PRINT_LABELS_COMMAND} #{temp_pdf}")
      flash[:info] = I18n.t("product.show.labels_sent_to_printer")
      redirect_to @product
    else
      send_file temp_pdf, :type => "application/pdf", :disposition => "inline"
    end
  end

end
