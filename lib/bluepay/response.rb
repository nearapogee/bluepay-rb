module Bluepay
  class Response

    LOCATION = 'Location'.freeze

    attr_reader :response, :action

    def initialize(http)
      @response = http
    end

    def bluepay_params
      URI.decode_www_form(URI(response['Location'].to_s).query).sort.to_h
    end

    def bluepay_data
      require 'csv'
      CSV.parse(response.body, headers: true)
    end

    def params
      bluepay_params.inject({}) { |memo, kv|
        k, v = kv
        memo[k.to_s.downcase.to_sym] = v
        memo
      }
    end

    def data
      bluepay_data.each.map {|r| OpenStruct.new(r.to_h)}
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
