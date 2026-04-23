# frozen_string_literal: true

module RubyLLM
  module Test
    # This class encapsulates all the parameters that are passed to the `complete` method of the wrapped provider. It
    # stores the raw arguments and uses the wrapped provider's actual method signature to expose named accessors for
    # inspection in tests.
    class CompleteParameters
      attr_reader :args, :kwargs, :block, :parameter_definitions

      def self.capture_from(provider, *args, **kwargs, &block)
        parameters = provider.method(:complete).parameters
        new(args:, kwargs:, block:, parameter_definitions: parameters)
      end

      def initialize(args:, kwargs:, block:, parameter_definitions:)
        @args = args
        @kwargs = kwargs
        @block = block
        @parameter_definitions = parameter_definitions
      end

      def block_received?
        !block.nil?
      end

      def [](name)
        name = name.to_sym
        return block if name == :block

        positional_name_to_value[name] || kwargs[name]
      end

      def key?(name)
        name = name.to_sym
        name == :block || positional_name_to_value.key?(name) || kwargs.key?(name)
      end

      def to_h
        positional_name_to_value.merge(kwargs).merge(block: block)
      end

      def method_missing(name, *call_args)
        return super unless call_args.empty?
        return self[name] if key?(name)

        super
      end

      def respond_to_missing?(name, include_private = false)
        key?(name) || super
      end

      private

      def positional_name_to_value
        @positional_name_to_value ||= begin
          positional_names = parameter_definitions
                             .select { |parameter| %i[req opt].include?(parameter.first) }
                             .map(&:last)

          positional_names.each_with_index.to_h { |param_name, index| [ param_name, args[index] ] }
        end
      end
    end
  end
end
