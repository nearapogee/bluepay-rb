module Bluepay
  class Void < TransactionBase

    def initialize(*args)
      super(*args)
      self.params[:transaction_type] = 'VOID'
    end

  end
end
