module Payment
  class Base
    def charge(amount, options = {})
      raise NotImplementedError, 'Subclasses must implement charge'
    end

    def refund(transaction_id, amount)
      raise NotImplementedError, 'Subclasses must implement refund'
    end
  end
end
