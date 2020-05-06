module Bluepay
  class Refund < TransactionBase

    def initialize(*args)
      super(*args)
      self.params[:transaction_type] = 'REFUND'
    end

  end
end
