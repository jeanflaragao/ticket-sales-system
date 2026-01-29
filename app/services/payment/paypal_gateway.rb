module Payment
  class PaypalGateway < Base
    def charge(amount, _options = {})
      # Simulated PayPal API call
      {
        success: true,
        transaction_id: "paypal_#{SecureRandom.hex(10)}",
        amount: amount
      }
    end

    def refund(_transaction_id, amount)
      {
        success: true,
        refund_id: "pp_refund_#{SecureRandom.hex(10)}",
        amount: amount
      }
    end
  end
end
