# frozen_string_literal: true

require_relative "test/errors/no_response_provided_error"
require_relative "test/test_provider"
require_relative "test/complete_parameters"

module RubyLLM
  # The Test module provides a simple way to stub responses from an LLM for testing purposes. You can use it to set up
  #  predetermined responses that your tests can rely on, allowing you to test your code's behavior without making
  #  actual calls to an LLM.
  module Test
    class << self
      def reset
        @responses = nil
      end

      # Pass in a RubyLLM::Message to have full control; strings and hashes will be wrapped in a message
      def stub_response(body)
        responses << body
      end

      def stub_responses(*bodies)
        responses.concat(bodies)
      end

      def with_responses(*bodies)
        previous_responses = responses.dup
        @responses = []
        stub_responses(*bodies)
        yield
      ensure
        @responses = previous_responses
      end

      def next_response
        responses.shift
      end

      def responses_empty?
        responses.empty?
      end

      def responses
        @responses ||= []
      end
    end
  end
end
