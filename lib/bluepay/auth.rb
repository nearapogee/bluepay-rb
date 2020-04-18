module Bluepay
  class Auth < Transaction
    include BP10EMU

    def initialize(*args)
      super(*args)
      @params[:transaction_type] = 'AUTH'
      @params[:rrno] = nil
    end

  end
end
