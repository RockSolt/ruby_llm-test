# frozen_string_literal: true

require "test_helper"

module RubyLLM
  module Test
    class CompleteParametersTest < Minitest::Test
      class ProviderDouble
        def complete(messages, tools:, temperature:, model:, params: {}, # rubocop:disable Metrics/ParameterLists
                     headers: {}, schema: nil, thinking: nil, tool_prefs: nil, &)
        end
      end

      def test_with_block
        params_with_block = CompleteParameters.capture_from(
          ProviderDouble.new,
          [],
          tools: [],
          temperature: 0.5,
          model: "test-model",
          params: {},
          headers: {},
          schema: nil,
          thinking: nil,
          tool_prefs: nil,
          &-> { "test block" }
        )

        assert_predicate params_with_block, :block_received?
      end

      def test_without_block
        params_without_block = CompleteParameters.capture_from(
          ProviderDouble.new,
          [],
          tools: [],
          temperature: 0.5,
          model: "test-model",
          params: {},
          headers: {},
          schema: nil,
          thinking: nil,
          tool_prefs: nil
        )

        refute_predicate params_without_block, :block_received?
      end

      def test_exposes_captured_arguments_by_name # rubocop:disable Metrics/AbcSize, Minitest/MultipleAssertions
        params = CompleteParameters.capture_from(
          ProviderDouble.new,
          [ Message.new(role: :user, content: "Hello") ],
          tools: %w[tool1 tool2],
          temperature: 0.7,
          model: "test-model",
          params: { param1: "value1" },
          headers: { "Authorization" => "Bearer token" },
          schema: { type: "object" },
          thinking: "thinking process",
          tool_prefs: { prefer_tool1: true }
        )

        assert_equal "Hello", params.messages.first.content.to_s
        assert_equal :user, params.messages.first.role
        assert_equal %w[tool1 tool2], params.tools
        assert_in_delta(0.7, params.temperature)
        assert_equal "test-model", params.model
        assert_equal({ param1: "value1" }, params.params)
        assert_equal({ "Authorization" => "Bearer token" }, params.headers)
        assert_equal({ type: "object" }, params.schema)
        assert_equal "thinking process", params.thinking
        assert_equal({ prefer_tool1: true }, params.tool_prefs)
      end

      def test_supports_hash_style_access # rubocop:disable Minitest/MultipleAssertions
        params = CompleteParameters.capture_from(
          ProviderDouble.new,
          [],
          tools: [],
          temperature: 0.5,
          model: "test-model"
        )

        assert_equal [], params[:messages]
        assert_equal [], params[:tools]
        assert_in_delta(0.5, params[:temperature])
        assert_equal "test-model", params[:model]
      end

      def test_to_h
        hash = {
          messages: [ Message.new(role: :user, content: "Hello") ],
          tools: %w[tool1 tool2],
          temperature: 0.7,
          model: "test-model",
          params: { param1: "value1" },
          headers: { "Authorization" => "Bearer token" },
          schema: { type: "object" },
          thinking: "thinking process",
          tool_prefs: { prefer_tool1: true },
          block: nil
        }
        params = CompleteParameters.capture_from(ProviderDouble.new, **hash)

        assert_equal hash, params.to_h
      end

      def test_invalid_parameter_access
        params = CompleteParameters.capture_from(ProviderDouble.new, [], tools: [], temperature: 0.5,
                                                                         model: "test-model")

        assert_raises(NoMethodError) { params.invalid_param }
      end

      def test_block_access_via_hash_style
        block = -> { "test block" }
        params = CompleteParameters.capture_from(ProviderDouble.new, [], tools: [], temperature: 0.5,
                                                                         model: "test-model", &block)

        assert_equal block, params[:block]
      end

      def test_respond_to_missing # rubocop:disable Minitest/MultipleAssertions
        params = CompleteParameters.capture_from(ProviderDouble.new, [], tools: [], temperature: 0.5,
                                                                         model: "test-model")

        assert_respond_to params, :messages
        assert_respond_to params, :tools
        assert_respond_to params, :temperature
        assert_respond_to params, :model
        refute_respond_to params, :invalid_param
      end
    end
  end
end
