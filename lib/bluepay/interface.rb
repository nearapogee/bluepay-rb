module Bluepay
  module Interface

    def tps(type, *args)
      _args = args.insert(0, Bluepay.account_id).map(&:to_s).join

      case type
      when HMAC_SHA512, nil
        OpenSSL::HMAC.hexdigest('sha512', Bluepay.account_secret, _args)
      when 'HMAC_SHA256'
        OpenSSL::HMAC.hexdigest('sha256', Bluepay.account_secret, _args)
      when 'SHA512'
        Digest::SHA512.hexdigest([
          Bluepay.account_secret,
          _args,
          type
        ].join)
      when 'SHA256'
        then Digest::SHA256.hexdigest([
          Bluepay.account_secret,
          _args,
          type
        ].join)
      when 'MD5'
        Digest::MD5.hexdigest([
          Bluepay.account_secret,
          _args,
          type
        ].join)
      else
        raise "Please set Bluepay.hash=."
      end
    end

    def path
      self.class::PATH
    end
    
    # DEPRICATED
    #
    def query
      URI.encode_www_form(data)
    end

    def data
      {
        'ACCOUNT_ID' => Bluepay.account_id
      }.merge(bluepay_params)
    end
  end
end

require 'bluepay/BP10EMU'
require 'bluepay/BPDAILYREPORT2'
