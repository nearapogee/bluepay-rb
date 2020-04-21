require 'bluepay/parameters'
require 'bluepay/tamper_proof_seal'
require "bluepay/request"
require "bluepay/response"

module Bluepay
  class Base
    include Parameters
    include TamperProofSeal

    attr_reader :request, :response

    def initialize(params={})
      self.params = params

      self.params[:mode] ||= Bluepay.mode.to_s.upcase
      self.params[:tps_hash_type] ||= Bluepay.hash_type
      self.params[:responseversion] ||= Bluepay.response_version
    end

  end
end

require 'bluepay/transaction_base'
