module Bluepay
  # bpdailyreport2 returns csv in body
  # bp10emu returns 302, html body, details are in Location header
  # stq returns query string in body
  #
  # #data returns a unified merge of all the data sources, with tabular data
  # under the key :rows as an array of OpenStruct instances
  class Response

    LOCATION = 'Location'.freeze

    attr_reader :response, :action

    def initialize(http)
      @response = http
    end

    def location_query_params
      URI.decode_www_form(URI(response['Location']).query).sort.to_h rescue {}
    end

    def body_params
      URI.decode_www_form(response.body).sort.to_h rescue {}
    end

    def params
      location_query_params.merge(body_params).inject({}) { |memo, kv|
        k, v = kv
        memo[k.to_s.downcase.to_sym] = v
        memo
      }
    end

    def body_csv
      require 'csv'
      CSV.parse(response.body, headers: true) rescue Array.new
    end

    def body_rows
      body_csv.each.map {|r| OpenStruct.new(r.to_h)}
    end

    def data
      params.to_h.merge(
        rows: body_rows
      )
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
