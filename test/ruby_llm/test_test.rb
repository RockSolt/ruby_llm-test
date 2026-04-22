# frozen_string_literal: true

require "test_helper"

module RubyLLM
  class TestTest < Minitest::Test
    def test_stub_response
      RubyLLM::Test.reset
      RubyLLM::Test.stub_response("test response")

      assert_equal "test response", RubyLLM::Test.next_response
    end

    def test_stub_responses
      RubyLLM::Test.reset
      RubyLLM::Test.stub_responses("response 1", "response 2")

      assert_equal "response 1", RubyLLM::Test.next_response
      assert_equal "response 2", RubyLLM::Test.next_response
    end

    def test_with_responses
      RubyLLM::Test.reset
      RubyLLM::Test.stub_response("initial response")

      RubyLLM::Test.with_responses("temp response 1", "temp response 2") do
        assert_equal "temp response 1", RubyLLM::Test.next_response
        assert_equal "temp response 2", RubyLLM::Test.next_response
      end

      # Ensure original responses are restored after the block
      assert_equal "initial response", RubyLLM::Test.next_response
    end

    def test_responses_empty
      RubyLLM::Test.reset

      assert_predicate RubyLLM::Test, :responses_empty?

      RubyLLM::Test.stub_response("not empty anymore")

      refute_predicate RubyLLM::Test, :responses_empty?
    end
  end
end
