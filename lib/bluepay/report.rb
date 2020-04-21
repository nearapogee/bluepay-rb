module Bluepay
  class Report < Base
    include BPDAILYREPORT2

    def self.generate!(params={})
      new(params).generate!
    end

    def initialize(params={})
      super(params)
    end

    def request_params
      bluepay_params.
        merge(tps(
          :report_start_date,
          :report_end_date
        ))
    end

    def generate!
      @request = Request.new(self)
      @response = request.execute!
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
