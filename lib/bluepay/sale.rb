module Bluepay
  class Sale < TransactionBase

    def initialize(*args)
      super(*args)
      self.params[:transaction_type] = 'SALE'
    end

  end
end
