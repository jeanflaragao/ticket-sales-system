module Payment
  class StripeGateway < Base
    def charge(amount, options = {})
      # Simulated Stripe API call
      {
        success: true,
        transaction_id: "stripe_#{SecureRandom.hex(10)}",
        amount: amount
      }
    end
    
    def refund(transaction_id, amount)
      {
        success: true,
        refund_id: "refund_#{SecureRandom.hex(10)}",
        amount: amount
      }
    end
  end
end