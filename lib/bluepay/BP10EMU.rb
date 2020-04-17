module Bluepay
  module BP10EMU
    include Interface
    PATH = "/interfaces/bp10emu".freeze

    def data
      {
        'MERCHANT' => Bluepay.account_id
      }.merge(bluepay_params)
    end

  end
end
