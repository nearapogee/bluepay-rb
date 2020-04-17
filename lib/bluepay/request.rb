require 'net/http'

module Bluepay
  class Request
    HOST = 'secure.bluepay.com'.freeze
    PORT = 443.freeze
    CERT = File.join(
      File.expand_path(File.dirname(__FILE__)),
      '../..',
      'cacert.pem'
    ).freeze


    attr_reader :action

    def initialize(action)
      @action = action
    end

    def post
      uri = URI::HTTPS.build(
        host: HOST,
        path: action.path
      )

      req = Net::HTTP::Post.new(uri)
      req.set_form_data(action.data)
      req['User-Agent'] = 'BluepayRB Ruby Client'
      req['Content-Type'] = 'application/x-www-form-urlencoded'

      res = Net::HTTP.start(
        HOST, PORT,
        use_ssl: true#,
        #ca_file: CERT,
        #verify_mode: OpenSSL::SSL::VERIFY_PEER,
        #verify_depth: 3
      ) { |http|
        http.request(req)
      }

      Response.new(res)
    end

    def tps_rebill
      @PARAM_HASH["TAMPER_PROOF_SEAL"] = tps_hash(
        @ACCOUNT_ID +
        @PARAM_HASH["TRANS_TYPE"] +
        @PARAM_HASH["REBILL_ID"],
        @PARAM_HASH['TPS_HASH_TYPE']
      )
    end

    # move to ReportApi superclass
    # Sets TAMPER_PROOF_SEAL in @PARAM_HASH for bpdailyreport2 API
    def tps_report
      @PARAM_HASH["TAMPER_PROOF_SEAL"] = tps_hash(
        @ACCOUNT_ID +
        @PARAM_HASH["REPORT_START_DATE"] +
        @PARAM_HASH["REPORT_END_DATE"],
        @PARAM_HASH['TPS_HASH_TYPE']
      )
    end

  end
end
