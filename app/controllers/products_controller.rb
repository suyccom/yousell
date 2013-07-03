class ProductsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show
  
  def new
    hobo_new do
      if @product.product_type
        @product.product_variations = []
        for v in @product.product_type.variations
          @product.product_variations << ProductVariation.new(:variation => v)
        end
      end
    end
  end

end
