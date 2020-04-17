module Bluepay
  class Transaction

    attr_reader :params, :source
    attr_reader :request, :response

    def initialize(params={})
      @params = params
      @source = params.delete(:source)
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }
      _bluepay_params.merge! source.bluepay_params

      _bluepay_params['MODE'] ||= Bluepay.mode.to_s.upcase
      _bluepay_params['TPS_HASH_TYPE'] ||= Bluepay.hash_type
      _bluepay_params['RESPONSEVERSION'] ||= Bluepay.response_version
      _bluepay_params['TAMPER_PROOF_SEAL'] = tps(_bluepay_params)

      _bluepay_params
    end

    def create!
      @request = Request.new(self)
      @response = request.post
      _params = response.params

      (class << self; self; end).class_eval do
        _params.each { |k, v| define_method(k) { v } }
      end
      self
    end

  end
end

require "bluepay/auth"
