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
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'
    
    barcode = Barby::Code128B.new('4561231')
    png = Barby::PngOutputter.new(barcode).to_png(:height => 20, :margin => 5)
    File.open('tmp/barcode.png', 'w'){|f| f.write png }

    names = ["", "Jordan", "Chris", "Jon", "Mike", "Kelly", "Bob", "Greg"]
    labels = Prawn::Labels.render(names, :type => "Avery5160") do |pdf, name|
      pdf.text name
      pdf.image "#{Rails.root}/tmp/barcode.png" unless name.blank?
    end
    send_data labels, :filename => "names.pdf", :type => "application/pdf", :disposition => "inline"
  end

end
