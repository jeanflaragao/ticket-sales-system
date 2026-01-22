class ProcessPaymentService
  attr_reader :errors, :transaction

  def initialize(order, payment_gateway: Payment::StripeGateway.new)
    @order = order
    @payment_gateway = payment_gateway
    @errors = []
    @transaction = nil
  end

  def call
    result = @payment_gateway.charge(@order.total)
    if result[:success]
      @transaction = result
      @order.update!(status: "confirmed")
    else
      @errors << "Payment failed"
    end

    self
  end

  def success?
    @errors.empty? && @transaction.present?
  end
end