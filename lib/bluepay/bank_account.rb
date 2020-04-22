module Bluepay
  class BankAccount
    include Parameters

    attr_reader :auth

    def initialize(params={})
      self.params = params
      self.params[:payment_type] = 'ACH'
    end

    def save!
      return self if @auth && @auth.trans_id && @auth.trans_id.length > 0

      @auth = Bluepay::Auth.new(
        amount: "0.00",
        source: self
      ).create!

      _params = @auth.to_h
      (class << self; self; end).class_eval do
        _params.each { |k, v| define_method(k) { v } }
      end
      self
    end

  end
end
