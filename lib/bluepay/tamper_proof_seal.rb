module Bluepay
  module TamperProofSeal

    def tps(*keys)
      type = self.params[:tps_hash_type]
      _params = self.converted_params
      args = keys.map {|k| _params[k] }
      { 'TAMPER_PROOF_SEAL' => hash(type, *args) }
    end

    def hash(type, *args)
      _args = args.insert(0, Bluepay.account_id).map(&:to_s).join

      case type
      when HMAC_SHA512, nil
        OpenSSL::HMAC.hexdigest('sha512', Bluepay.secret_key, _args)
      when HMAC_SHA256
        OpenSSL::HMAC.hexdigest('sha256', Bluepay.secret_key, _args)
      when SHA512
        Digest::SHA512.hexdigest([
          Bluepay.secret_key,
          _args,
          type
        ].join)
      when SHA256
        then Digest::SHA256.hexdigest([
          Bluepay.secret_key,
          _args,
          type
        ].join)
      when MD5
        Digest::MD5.hexdigest([
          Bluepay.secret_key,
          _args,
          type
        ].join)
      else
        raise "Please set Bluepay.hash=."
      end
    end

  end
end
