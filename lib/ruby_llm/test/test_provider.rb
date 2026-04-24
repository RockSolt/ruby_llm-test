# frozen_string_literal: true

module RubyLLM
  module Test
    # This class serves as a test double for the provider used in the `RubyLLM::Test` class. It captures all calls to
    #  the `complete` method, allowing tests to assert that the correct parameters were passed and to simulate
    #  responses from the provider.
    class TestProvider < SimpleDelegator
      def initialize(provider, test_harness)
        super(provider)
        @test_harness = test_harness
      end

      def complete(...)
        parameters = CompleteParameters.capture_from(__getobj__, ...)
        @test_harness.record_request(parameters)
        raise Errors::NoResponseProvidedError, parameters.messages if @test_harness.responses_empty?

        response = @test_harness.next_response
        return response if response.is_a?(Message)

        Message.new(
          role: :assistant,
          content: response.is_a?(Hash) ? response.to_json : response
        )
      end
    end
  end
end
