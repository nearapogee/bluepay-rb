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

    def execute!
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

  end
end
