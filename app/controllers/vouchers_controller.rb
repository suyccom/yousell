class VouchersController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :show

  def index
    # Añadir paginación y búsqueda por estado
    hobo_index
  end

end
