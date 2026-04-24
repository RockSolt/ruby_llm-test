# frozen_string_literal: true

module RubyLLM
  module Test
    # This class serves as a test harness for stubbing responses and recording requests sent to the provider.
    # It allows tests to set up expected responses and then verify that the provider received the correct
    # parameters.
    class Harness
      attr_reader :requests

      def initialize
        reset
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

      def record_request(request)
        requests << request
      end

      def last_request
        requests.last
      end

      def clear_requests
        requests.clear
      end

      def reset
        @responses = []
        @requests = []
      end

      private

      def responses
        @responses ||= []
      end
    end
  end
end
