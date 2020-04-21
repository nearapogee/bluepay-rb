module Bluepay
  class TransactionBase < Base
    include BP10EMU

    attr_accessor :source

    def initialize(*args)
      super(*args)
      self.params[:rrno] = nil

      self.source = params.delete(:source)
    end

    def self.create!(params={})
      new(params).create!
    end

    def create!
      @request = Request.new(self)
      @response = request.execute!
      _params = response.params

      (class << self; self; end).class_eval do
        _params.each { |k, v| define_method(k) { v } }
      end
      self
    end

    convert :amount, ->(amount) {
      case amount
      when Integer then amount.to_s.rjust(3, '0').insert(-3, '.')
      when Float then "%.2f" % amount
      else
        amount
      end
    }

    def request_params
      bluepay_params.
        merge(source.bluepay_params).
        merge(tps(
          :transaction_type,
          :amount,
          :rebilling,
          :reb_first_date,
          :reb_expr,
          :reb_cycles,
          :reb_amount,
          :rrno,
          :mode
        ))
    end

  end
end

require 'bluepay/auth'
require 'bluepay/sale'
