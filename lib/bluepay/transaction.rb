module Bluepay
  class Transaction < Base
    include STQ

    def self.retrieve!(id, params = {})
      new(params.merge(id: id)).retrieve!
    end

    def self.query!(params = {})
      new(params).retrieve!
    end

    def initialize(params={})
      super(params)
    end

    convert :limit_one, :exclude_errors,
      :f_captured, :isnull_f_captured,
      BOOLEAN_CONVERTER

    def request_params
      bluepay_params.
        merge(tps(
          :report_start_date,
          :report_end_date
        ))
    end

    def retrieve!
      @request = Request.new(self)
      @response = request.execute!

      _data = response.data
      (class << self; self; end).class_eval do
        _data.each { |k, v| define_method(k) { v } }
      end

      self
    end

    def to_h
      response.data
    end

  end
end
