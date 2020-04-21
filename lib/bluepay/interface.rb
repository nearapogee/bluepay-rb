require 'bluepay/parameters'

module Bluepay
  module Interface
    include Parameters

    def path
      self.class::PATH
    end

    def data
      {
        'ACCOUNT_ID' => Bluepay.account_id
      }.merge(request_params)
    end

  end
end

require 'bluepay/BP10EMU'
require 'bluepay/BPDAILYREPORT2'
