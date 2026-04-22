# frozen_string_literal: true

require "test_helper"

module RubyLLM
  module Test
    class CompleteParametersTest < Minitest::Test
      def test_with_block
        params_with_block = CompleteParameters.new(
          messages: [], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {}, schema: nil,
          thinking: nil, tool_prefs: nil,
          block: -> { "test block" }
        )

        assert_predicate params_with_block, :block_received?
      end

      def test_without_block
        params_without_block = CompleteParameters.new(
          messages: [], tools: [], temperature: 0.5, model: "test-model", params: {}, headers: {}, schema: nil,
          thinking: nil, tool_prefs: nil,
          block: nil
        )

        refute_predicate params_without_block, :block_received?
      end
    end
  end
end
