module Bluepay
  class Report
    include BPDAILYREPORT2

    attr_reader :params, :source
    attr_reader :request, :response

    def self.generate!(params={})
      new(params).generate!
    end

    def initialize(params={})
      @params = params
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }

      _bluepay_params['MODE'] ||= Bluepay.mode.to_s.upcase
      _bluepay_params['TPS_HASH_TYPE'] ||= Bluepay.hash_type
      _bluepay_params['RESPONSEVERSION'] ||= Bluepay.response_version
      _bluepay_params['TAMPER_PROOF_SEAL'] = tps(
        _bluepay_params['TPS_HASH_TYPE'],
        _bluepay_params['REPORT_START_DATE'],
        _bluepay_params['REPORT_END_DATE']
      )

      _bluepay_params
    end

    def generate!
      @request = Request.new(self)
      @response = request.post
      self
    end

    def rows
      response.data
    end
    
  end
end
