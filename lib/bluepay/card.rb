module Bluepay
  class Card

    attr_reader :params

    def initialize(params={})
      @params = params
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }

      _bluepay_params['PAYMENT_TYPE'] = 'CREDIT'
      _bluepay_params
    end
  end
end
