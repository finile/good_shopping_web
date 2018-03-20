class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def create
    # manually check if user logged in
    if current_user.nil?
      # store order data in session so we can retrieve it later
      session[:new_order_data] = params[:order]
      # redirect to devise login page
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
        redirect_to orders_path, notice: "new order created"
      else
        @items = current_cart.cart_items
        render "carts/show"
      end
    end
  end

  def update
    @order = current_user.orders.find(params[:id])
    if @order.shipping_status == "not_shipped"
      @order.shipping_status = "cancelled"
      @order.save
      redirect_to orders_path, alert: "order##{@order.sn} cancelled."
    end
  end

  def checkout_spgateway
    @order = current_user.orders.find(params[:id])
    if @order.payment_status != "not_paid"
      flash[:alert] = "Order has been paid."
      redirect_to orders_path
    else
      @payment = Payment.create!(
        sn: Time.now.to_i,
        order_id: @order.id,
        amount: @order.amount
      )


      # get params string
      spgateway_data = {
        MerchantID: "MS33487888",
        Version: 1.4,
        RespondType: "JSON",
        TimeStamp: Time.now.to_i,
        MerchantOrderNo: "#{@payment.id}AC",
        Amt: @order.amount,
        ItemDesc: @order.name,
        Email: @order.user.email,
        LoginType: 0,
        ReturnURL: spgateway_return_url
      }.to_query


      # AES encrypt

      hash_key = "TYiU1DmujbmURuMe0Htc6sep2Er4xD0L"
      hash_iv = "JhTNuxOHK7jDcZQQ"

      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt
      cipher.key = hash_key
      cipher.iv  = hash_iv
      encrypted = cipher.update(spgateway_data) + cipher.final
      aes = encrypted.unpack('H*').first

      # SHA256

      str = "HashKey=#{hash_key}&#{aes}&HashIV=#{hash_iv}"
      sha = Digest::SHA256.hexdigest(str).upcase

      # set form instance variable
      @merchant_id = "MS33487888"
      @trade_info = aes
      @trade_sha = sha
      @version = "1.4"

      render layout: false
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone, :address, :payment_method)
  end
end