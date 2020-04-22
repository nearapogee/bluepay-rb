require 'net/http'

module Bluepay
  class Request
    HOST = 'secure.bluepay.com'.freeze
    PORT = 443.freeze

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
        use_ssl: true,
      ) { |http| http.request(req) }

      Response.new(res)
    end

  end
end
