module Bluepay
  class Auth < TransactionBase

    def initialize(*args)
      super(*args)
      self.params[:transaction_type] = 'AUTH'
    end

  end
end
