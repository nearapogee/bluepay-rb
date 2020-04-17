require "bluepay/version"
require "bluepay/transaction"
require "bluepay/card"
require "bluepay/request"
require "bluepay/response"

module Bluepay

  HMAC_SHA512 = 'HMAC_SHA512'.freeze # TODO add others!

  class << self
    attr_accessor :account_id, :account_secret
    attr_writer :mode, :hash_type, :response_version

    def mode
      @mode ||= :test
    end

    def hash_type
      @hash_type ||= HMAC_SHA512
    end

    def response_version
      @response_version ||= '5'
    end
  end
end
