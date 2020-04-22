require "bluepay/version"

require "bluepay/interface"
require "bluepay/base"

require "bluepay/card"
require "bluepay/bank_account"

module Bluepay

  HMAC_SHA512 = 'HMAC_SHA512'.freeze
  HMAC_SHA256 = 'HMAC_SHA256'.freeze
  SHA512 = 'SHA512'.freeze
  SHA256 = 'SHA256'.freeze
  MD5 = 'MD5'.freeze

  class << self
    attr_accessor :account_id, :secret_key
    attr_writer :mode, :hash_type, :response_version

    def mode
      @mode ||= :test
    end

    def hash_type
      @hash_type ||= HMAC_SHA512
    end

    def response_version
      @response_version ||= '11'
    end
  end
end
