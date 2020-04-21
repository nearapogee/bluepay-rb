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

      @params[:mode] ||= Bluepay.mode.to_s.upcase
      @params[:tps_hash_type] ||= Bluepay.hash_type
      @params[:responseversion] ||= Bluepay.response_version
    end

    def bluepay_params
      _bluepay_params = params.inject(Hash.new) { |memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }

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

    def [](id)
      response.data.first { |row| row.id == id }
    end
    
  end
end
