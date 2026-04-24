# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

module RubyLLM
  class TestTest < Minitest::Test
    def setup
      @original_harness = RubyLLM::Test.instance_variable_get(:@harness)
      @mock_harness = Minitest::Mock.new
      RubyLLM::Test.instance_variable_set(:@harness, @mock_harness)
    end

    def teardown
      RubyLLM::Test.instance_variable_set(:@harness, @original_harness)
    end

    def test_reset_forwards_to_harness
      @mock_harness.expect(:reset, nil)

      RubyLLM::Test.reset

      @mock_harness.verify
    end

    def test_stub_response_forwards_to_harness
      @mock_harness.expect(:stub_response, nil, [ "test response" ])

      RubyLLM::Test.stub_response("test response")

      @mock_harness.verify
    end

    def test_stub_responses_forwards_to_harness
      @mock_harness.expect(:stub_responses, nil, [ "response 1", "response 2" ])

      RubyLLM::Test.stub_responses("response 1", "response 2")

      @mock_harness.verify
    end

    def test_with_responses_forwards_arguments_and_block_to_harness
      block_called = false

      @mock_harness.expect(:with_responses, nil) do |*bodies, &block|
        assert_equal [ "temp response 1", "temp response 2" ], bodies
        refute_nil block

        block.call
      end

      RubyLLM::Test.with_responses("temp response 1", "temp response 2") do
        block_called = true
      end

      assert block_called
      @mock_harness.verify
    end

    def test_requests_returns_value_from_harness
      requests = [ Object.new ]
      @mock_harness.expect(:requests, requests)

      assert_equal requests, RubyLLM::Test.requests

      @mock_harness.verify
    end

    def test_last_request_returns_value_from_harness
      request = Object.new
      @mock_harness.expect(:last_request, request)

      assert_equal request, RubyLLM::Test.last_request

      @mock_harness.verify
    end

    def test_clear_requests_forwards_to_harness
      @mock_harness.expect(:clear_requests, nil)

      RubyLLM::Test.clear_requests

      @mock_harness.verify
    end
  end
end
