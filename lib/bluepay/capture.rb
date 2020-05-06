module Bluepay
  class Capture < TransactionBase

    def initialize(*args)
      super(*args)
      self.params[:transaction_type] = 'CAPTURE'
    end

  end
end
