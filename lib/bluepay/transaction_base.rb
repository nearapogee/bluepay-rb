module Bluepay
  class TransactionBase < Base
    include BP10EMU

    attr_accessor :source

    def initialize(*args)
      super(*args)
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

    def to_h
      response.data
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
      _params = bluepay_params
      _params.merge!(source.bluepay_params) if source
      _params.merge!(tps(
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
      _params
    end

  end
end

require 'bluepay/auth'
require 'bluepay/sale'
require 'bluepay/capture'
require 'bluepay/void'
require 'bluepay/refund'
