module Bluepay
  module Parameters

    def self.included(receiver)
      receiver.attr_writer :params
    end

    def params
      @params ||= Hash.new
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }
      _bluepay_params
    end

  end
end
