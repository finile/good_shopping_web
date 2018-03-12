class OrdersController < ApplicationController

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def create
    if current_user.nil?
      session[:new_order_data] = params[:order]
      redirect_to new_user_session_path
    else
      @order = current_user.orders.new(order_params)
      @order.sn = Time.now.to_i
      @order.add_order_items(current_cart)
      @order.amount = current_cart.subtotal
      if @order.save
        current_cart.destroy
        session.delete(:new_order_data)
        # UserMailer.notify_order_create(@order).deliver_now!
        flash[:notice] = "order was created"
        redirect_to orders_path
      else
        @itmes = current_cart.cart_items
        flash.now[:alert] = "order was failed to create"
        redirect_to cart_path
      end
    end
  end


  private

  def order_params
    params.require(:order).permit(:name, :phone, :address, :payment_method)
  end

end


