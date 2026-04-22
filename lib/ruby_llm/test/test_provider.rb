# frozen_string_literal: true

module RubyLLM
  module Test
    # This class serves as a test double for the provider used in the `RubyLLM::Test` class. It captures all calls to
    #  the `complete` method, allowing tests to assert that the correct parameters were passed and to simulate
    #  responses from the provider.
    class TestProvider < SimpleDelegator
      extend Forwardable

      attr_reader :complete_calls

      def_delegators :last_call, :messages, :tools, :temperature, :model, :params, :headers, :schema, :thinking,
                     :tool_prefs, :block_received?

      def initialize(provider, test_harness = RubyLLM::Test)
        super(provider)
        @test_harness = test_harness
        @complete_calls = []
      end

      def complete(messages, tools:, temperature:, model:, params: {}, # rubocop:disable Metrics/ParameterLists
                   headers: {}, schema: nil, thinking: nil, tool_prefs: nil, &block)
        @complete_calls << CompleteParameters.new(messages:, tools:, temperature:, model:, params:, headers:, schema:,
                                                  thinking:, tool_prefs:, block:)
        raise Errors::NoResponseProvidedError, messages if @test_harness.responses_empty?

        response = @test_harness.next_response
        return response if response.is_a?(Message)

        Message.new(
          role: :assistant,
          content: response.is_a?(Hash) ? response.to_json : response
        )
      end

      def last_call
        @complete_calls.last
      end
    end
  end
end
