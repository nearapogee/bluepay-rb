$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bluepay"

require 'dotenv/load'

require 'binding_of_caller'
require 'pry'

require "minitest/autorun"

Bluepay.account_id = ENV['BLUEPAY_ACCOUNT_ID']
Bluepay.secret_key = ENV['BLUEPAY_SECRET_KEY']
Bluepay.mode = :test
Bluepay.hash_type = Bluepay::HMAC_SHA512
