require 'date'

module Bluepay
  class Report < Base
    include BPDAILYREPORT2

    def self.generate!(params={})
      new(params).generate!
    end

    def initialize(params={})
      super(params)
    end

    convert :report_start_date, :report_end_date, ->(date) {
      case date
      when Date, DateTime then date.strftime("%F %T")
      else
        date
      end
    }

    convert :query_by_settlement,
      :query_by_hierarchy,
      :exclude_errors,
      BOOLEAN_CONVERTER

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

      _data = response.data
      (class << self; self; end).class_eval do
        _data.each { |k, v| define_method(k) { v } }
      end

      self
    end

    def [](id)
      return nil unless self.respond_to?(:rows)
      @_lookup ||= self.rows.inject({}) { |memo, row|
        memo[row.id] = row
        memo
      }
      @_lookup[id]
    end

  end
end
