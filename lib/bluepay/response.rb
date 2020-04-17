module Bluepay
  class Response

    LOCATION = 'Location'.freeze

    attr_reader :response, :action

    def initialize(http)
      @response = http
    end

    def bluepay_params
      if response[LOCATION]
        URI.decode_www_form(URI(response['Location']).query).sort.to_h
      else
        URI.decode_www_form(response.body).sort.to_h
      end
    end

    def params
      bluepay_params.inject({}) { |memo, kv|
        k, v = kv
        memo[k.to_s.downcase.to_sym] = v
        memo
      }
    end

    def code
      response.code.to_i
    end

    def body
      response.body
    end

    def headers
      response.to_hash
    end
  end
end
