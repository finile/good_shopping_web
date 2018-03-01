class Admin::ProductsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_product, only: [:show, :edit, :update, :destroy] 

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flas[:notice] = "prduct was created"
      redirect_to admin_products_path
    else
      flash.now[:alert] = "product was failed to create"
      render :new
    end
  end

  def show    
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "product was upddated"
      redirect_to admin_products_path(@product)
    else
      flash.now[:alert] = "product was failed to update"
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path
    flash[:alert] = "Prodcut was deleted"  
  end

private
  
  def set_product
    @product = Product.find(params[:id])  
  end


  def product_params
    params.require(:product).permit(:name, :description, :price, :image)
  end


end
