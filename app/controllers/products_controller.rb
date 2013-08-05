class ProductsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :create]
  
  autocomplete
  
  def print_labels
    @product = Product.find(params[:id])

    temp_file = "#{Rails.root}/tmp/barcode.png"
    temp_pdf = "#{Rails.root}/tmp/labels.pdf"
   
    # Create the barcode PNG
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'
    barby = Barby::Code128B.new(@product.barcode)
    png = Barby::PngOutputter.new(barby).to_png(:height => 25, :margin => 5, :xdim => 1)
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
    
    Prawn::Labels.types = {
      "Apli1285" => {
        "paper_size" => "A4",
        "columns"    => 4,
        "rows"       => 11,
        "top_margin" => 18.0,
        "bottom_margin" => 19.0,
        "left_margin" => 28.5,
        "right_margin" => 18.5
    }}
    
    labels = Prawn::Labels.generate(temp_pdf, barcodes, :type => "Apli1285") do |pdf, barcode|
      unless barcode.blank?
        pdf.image barcode 
        pdf.text @product.barcode, :size => 10
        pdf.text @product.name, :size => 10
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

  def index
    if params[:last_added]
      products = Product.where(:id => User.current_user.last_added_products.map{|p| p[0]})
    else
      products = Product.apply_scopes(:order_by => parse_sort_param(:name))
    end
    hobo_index products
  end

end
