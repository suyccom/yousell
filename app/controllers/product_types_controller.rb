class ProductTypesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

end
