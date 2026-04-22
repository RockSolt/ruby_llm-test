# frozen_string_literal: true

require "test_helper"

module RubyLLM
  module Test
    module Errors
      class NoResponseProvidedErrorTest < Minitest::Test
        def test_error_message_includes_last_message_content
          messages = [
            Message.new(role: :user, content: "What is the capital of France?"),
            Message.new(role: :assistant, content: "The capital of France is Paris.")
          ]

          error = NoResponseProvidedError.new(messages)

          assert_includes error.message, messages.last.content
        end

        def test_handles_empty_messages
          error = NoResponseProvidedError.new([])

          assert_includes error.message, "No test response provided for the following request:"
        end
      end
    end
  end
end
