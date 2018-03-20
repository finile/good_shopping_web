class SpgatewayController < ActionController::Base

  def return
    # trade_info = spgateway_params['TradeInfo']
    # trade_sha = spgateway_params['TradeSha']

    # data = Spgateway.decrypt(trade_info, trade_sha)

    # if data
    #   payment = Payment.find(data['Result']['MerchantOrderNo'].to_i)
    #   if params['Status'] == 'SUCCESS'
    #     payment.paid_at = Time.now
    #   end
    #   payment.params = data
    # end

    payment = Payment.find_and_process(spgateway_params)

    if payment&.save
      # send paid email
      flash[:notice] = "#{payment.sn} paid"
    else
      flash[:alert] = "Something wrong!!!"
    end

    redirect_to orders_path
  end

  def notify
    payment = Payment.find_and_process(spgateway_params)

    if payment&.save
      # send paid email
      render text: "1|OK"
    else
      render text: "0|ErrorMessage"
    end
    byebug
  end

  private

  def spgateway_params
    params.slice("Status", "MerchantID", "Version", "TradeInfo", "TradeSha")
  end


end