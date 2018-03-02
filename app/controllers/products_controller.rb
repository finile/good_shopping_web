class ProductsController < ApplicationController

  def index
    @products = Product.page(params[:page]).per(12)
  end

  def add_to_cart
    @product = Product.find(params[:id])
    current_cart.add_cart_item(@product)

    redirect_to root_path
  end


end
