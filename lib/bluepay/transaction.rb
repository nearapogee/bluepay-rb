module Bluepay
  class Transaction

    attr_reader :params, :source
    attr_reader :request, :response

    def initialize(params={})
      @params = params
      @params[:mode] ||= Bluepay.mode.to_s.upcase
      @params[:tps_hash_type] ||= Bluepay.hash_type
      @params[:responseversion] ||= Bluepay.response_version

      @source = params.delete(:source)
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }
      _bluepay_params.merge! source.bluepay_params

      _bluepay_params['TAMPER_PROOF_SEAL'] = tps(
        _bluepay_params['TPS_HASH_TYPE'],
        _bluepay_params['TRANSACTION_TYPE'],
        _bluepay_params['AMOUNT'],
        _bluepay_params['REBILLING'],
        _bluepay_params['REB_FIRST_DATE'],
        _bluepay_params['REB_EXPR'],
        _bluepay_params['REB_CYCLES'],
        _bluepay_params['REB_AMOUNT'],
        _bluepay_params['RRNO'],
        _bluepay_params['MODE']
      )

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
