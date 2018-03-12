class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_cart

  private

  def after_sign_in_path_for(resource)
    if session[:new_order_data].present?
      @cart = Cart.find(session[:cart_id])
      cart_path(@cart)
    else
      super
    end
  end

  def authenticate_admin!
    unless current_user.admin?
      raise "Page doesn't exist"
      redirect_to root_path
    end
  end

  def current_cart
    @cart || set_cart # return @cart if @cart exist, or call set_cart
  end

  def set_cart

    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    @cart ||= Cart.create

    session[:cart_id] = @cart.id
    @cart
  end
end