class ProductsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :create]
  
  autocomplete
  
  def generate_labels(empty_cells, products)
    require 'barby'
    require 'barby/barcode/code_93'
    require 'barby/outputter/png_outputter'

    Prawn::Labels.types = {
      "Apli1285" => {
        "paper_size" => "A4",
        "columns"    => 4,
        "rows"       => 10,
        "top_margin" => 65.0,
        "bottom_margin" => 55.0,
        "left_margin" => 40.5,
        "right_margin" => 15.5
    }}
    
    # Create the array for the labels PDF
    barcodes = []
    params[:empty_cells].to_i.times do
      barcodes << {}
    end
    
    for product in products
      # Create the barcode PNGs
      temp_png = "#{Rails.root}/tmp/barcode-#{product[0].id}.png"
      barby = Barby::Code93.new(product[0].barcode)
      png = Barby::PngOutputter.new(barby).to_png(:height => 35, :margin => 5, :xdim => 1)
      File.open(temp_png, 'w'){|f| f.write png }
      # Add the label to the barcodes array
      product[1].to_i.times do
        barcodes << {:png => temp_png, :barcode => product[0].barcode, :name => product[0].name}
      end
    end

    # Generate the PDF
    temp_pdf = "#{Rails.root}/tmp/labels.pdf"
    labels = Prawn::Labels.generate(temp_pdf, barcodes, :type => "Apli1285") do |pdf, barcode|
      unless barcode.blank?
        pdf.image barcode[:png], :scale => 0.72
        pdf.text  barcode[:barcode], :indent_paragraphs => 23, :size => 9
        pdf.text  barcode[:name], :indent_paragraphs => 5, :size => 9
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

  def product_labels
    product = Product.find(params[:id])
    products = [[ product, params[:number] ]]
    generate_labels(params[:empty_cells], products)
  end
  
  def last_products_labels
    products = User.current_user.last_added_products.map{|p| [Product.find(p[0]), p[1]] }
    generate_labels(params[:empty_cells], products)
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
      :variaciones => variaciones.join(",")
    )



  end

end
