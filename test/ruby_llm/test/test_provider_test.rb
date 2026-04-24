# frozen_string_literal: true

require "test_helper"

module RubyLLM
  module Test
    class TestProviderTest < Minitest::Test
      class ProviderDouble
        def complete(messages, tools:, temperature:, model:, params: {}, # rubocop:disable Metrics/ParameterLists
                     headers: {}, schema: nil, thinking: nil, tool_prefs: nil, &)
        end
      end

      def setup
        RubyLLM::Test.reset
      end

      def test_provider_returns_stubbed_response
        RubyLLM::Test.stub_response("stubbed response")

        provider = TestProvider.new(ProviderDouble.new, RubyLLM::Test.send(:harness))
        response = provider.complete([], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {})

        assert_kind_of Message, response
        assert_equal "stubbed response", response.content
      end

      def test_when_response_not_stubbed
        provider = TestProvider.new(ProviderDouble.new, RubyLLM::Test.send(:harness))
        message = Message.new(role: :user, content: "What is the capital of France?")

        exception = assert_raises(Errors::NoResponseProvidedError) do
          provider.complete([ message ], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {})
        end

        assert_includes exception.message, message.content
      end

      def test_when_stub_is_a_message
        stubbed_message = Message.new(role: :assistant, content: "This is a stubbed message.")
        RubyLLM::Test.stub_response(stubbed_message)

        provider = TestProvider.new(ProviderDouble.new, RubyLLM::Test.send(:harness))
        response = provider.complete([], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {})

        assert_equal stubbed_message, response
      end

      def test_hash_stub_is_converted_to_json_message
        stubbed_hash = { answer: "42" }
        RubyLLM::Test.stub_response(stubbed_hash)

        provider = TestProvider.new(ProviderDouble.new, RubyLLM::Test.send(:harness))
        response = provider.complete([], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {})

        assert_kind_of Message, response
        assert_equal stubbed_hash.to_json, response.content
      end
    end

    # class TestProviderLastCallTest < Minitest::Test
    #   class ProviderDouble
    #     def complete(messages, tools:, temperature:, model:, params: {},
    #                  headers: {}, schema: nil, thinking: nil, tool_prefs: nil, &)
    #     end
    #   end

    #   def setup
    #     RubyLLM::Test.reset
    #     RubyLLM::Test.stub_response("stubbed response")

    #     initialize_arguments
    #     provider = TestProvider.new(ProviderDouble.new, RubyLLM::Test)
    #     provider.complete(@messages, tools: @tools, temperature: @temperature, model: @model, params: @params,
    #                                  headers: @headers, schema: @schema, thinking: @thinking, tool_prefs: @tool_prefs)

    #     @last_call = RubyLLM::Test.last_request
    #   end

    #   def test_last_call_captures_messages
    #     assert_equal @messages, @last_call.messages
    #   end

    #   def test_last_call_captures_tools
    #     assert_equal @tools, @last_call.tools
    #   end

    #   def test_last_call_captures_temperature
    #     assert_equal @temperature, @last_call.temperature
    #   end

    #   def test_last_call_captures_model
    #     assert_equal @model, @last_call.model
    #   end

    #   def test_last_call_captures_params
    #     assert_equal @params, @last_call.params
    #   end

    #   def test_last_call_captures_headers
    #     assert_equal @headers, @last_call.headers
    #   end

    #   def test_last_call_captures_schema
    #     assert_equal @schema, @last_call.schema
    #   end

    #   def test_last_call_captures_thinking
    #     assert_equal @thinking, @last_call.thinking
    #   end

    #   def test_last_call_captures_tool_prefs
    #     assert_equal @tool_prefs, @last_call.tool_prefs
    #   end

    #   private

    #   def initialize_arguments
    #     @messages = [ Message.new(role: :user, content: "Hello") ]
    #     @tools = %w[tool1 tool2]
    #     @temperature = 0.7
    #     @model = "test-model"
    #     @params = { param1: "value1" }
    #     @headers = { "Authorization" => "Bearer token" }
    #     @schema = { type: "object" }
    #     @thinking = "thinking process"
    #     @tool_prefs = { prefer_tool1: true }
    #   end
    # end
  end
end
