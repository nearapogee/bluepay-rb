module Bluepay
  module Parameters

    DEFAULT_CONVERTER = ->(value) { value.to_s }
    BOOLEAN_CONVERTER = ->(value) {
      case value
      when TrueClass then '1'
      when FalseClass then '0'
      else
        value
      end
    }

    def self.included(receiver)
      receiver.attr_writer :params
      receiver.extend ClassMethods
    end

    module ClassMethods
      def convert(*args)
        converter = args.pop
        args.each {|arg| self.converters[arg] = converter }
      end

      def converters
        @_converters ||= Hash.new
      end

      def converter(param)
        converter = self.converters[param]
        converter ||= self.superclass.converter(param) rescue nil
        converter
      end

      def convert!(param, value)
        converter = converter(param)
        converter ||= DEFAULT_CONVERTER
        converter.call(value)
      end
    end

    def params
      @params ||= Hash.new
    end

    def converted_params
      params.inject(Hash.new) {|memo, kv|
        k, v = kv
        memo[k] = self.class.convert!(k, v)
        memo
      }
    end

    def bluepay_params
      converted_params.inject(Hash.new) {|memo, kv|
        k, v = kv
        memo[k.to_s.upcase] = v
        memo
      }
    end

  end
end
