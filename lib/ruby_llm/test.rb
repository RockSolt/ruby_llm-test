# frozen_string_literal: true

require "ruby_llm"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(RubyLLM)
loader.setup

module RubyLLM
  # The Test module provides a simple way to stub responses from an LLM for testing purposes.
  # You can use it to set up predetermined responses that your tests can rely on, allowing
  # you to test your code's behavior without making actual calls to an LLM.
  module Test
    class << self
      # Reset the test harness state.
      #
      # This clears all queued stubbed responses and all recorded requests.
      #
      # Use this at the start of a test, or whenever you want to ensure no state
      # carries over from a previous example.
      def reset
        harness.reset
      end

      # Queue a single stubbed response.
      #
      # Parameters:
      #
      # - `body`: The response to queue. Pass a `RubyLLM::Message` to control the
      #   message directly. Strings and hashes are wrapped in a message
      #   automatically.
      #
      # This is useful when your test only needs one response from the model.
      #
      # Example:
      #
      #     RubyLLM::Test.stub_response("Hello from the test harness!")
      #
      #     chat = RubyLLM.chat
      #     response = chat.ask("Say hello")
      #     response.content
      #     # => "Hello from the test harness!"
      def stub_response(body)
        harness.stub_response(body)
      end

      # Queue multiple stubbed responses.
      #
      # Parameters:
      #
      # - `*bodies`: One or more responses to queue.
      #
      # Responses are returned in the same order they are provided, making this
      # useful for tests that perform multiple LLM calls in sequence.
      #
      # Example:
      #
      #     RubyLLM::Test.stub_responses("First reply", "Second reply")
      #
      #     chat = RubyLLM.chat
      #     first_response = chat.ask("First question")
      #     second_response = chat.ask("Second question")
      #
      #     first_response.content
      #     # => "First reply"
      #     second_response.content
      #     # => "Second reply"
      def stub_responses(*bodies)
        harness.stub_responses(*bodies)
      end

      # Run a block with a temporary set of stubbed responses.
      #
      # Parameters:
      #
      # - `*bodies`: The responses to make available inside the block.
      # - `&block`: The code to run while those responses are active.
      #
      # The provided responses are available only for the duration of the block.
      # This is useful when you want to scope stubbed responses to a single part
      # of a test without affecting later assertions.
      #
      # Example:
      #
      #     RubyLLM::Test.with_responses("Scoped reply") do
      #       chat = RubyLLM.chat
      #       chat.ask("Question")
      #     end
      def with_responses(*bodies, &)
        harness.with_responses(*bodies, &)
      end

      # Return all recorded requests.
      #
      # This is useful for assertions about prompts, parameters, or other request
      # details captured by the harness.
      def requests
        harness.requests
      end

      # Return the most recent request.
      #
      # Use this when you only care about the latest request made during a test.
      def last_request
        harness.last_request
      end

      # Clear all recorded requests.
      #
      # This leaves queued responses unchanged.
      def clear_requests
        harness.clear_requests
      end

      private

      def harness
        @harness ||= Harness.new
      end
    end
  end
end
