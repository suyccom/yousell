class FrontController < ApplicationController

  hobo_controller

  def index; end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

  def search_products
    clauses = []
    args = []
    for value in params[:term].split(" ")
      clauses << "products.metabusqueda LIKE ?"
      args << "%#{value}%"
    end
    clause = clauses.join(' AND '), *args
    logger.info "esto es clause #{clause}"
    @products = Product.where(clause)
    hobo_ajax_response
  end

end
