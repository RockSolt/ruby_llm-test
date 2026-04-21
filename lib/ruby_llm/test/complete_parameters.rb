# frozen_string_literal: true

module RubyLLM
  module Test
    # This class encapsulates all the parameters that are passed to the `complete` method of the `Test` class. It
    # serves as a structured way to manage and access these parameters throughout the testing process.
    class CompleteParameters
      attr_reader :messages, :tools, :temperature, :model, :params, :headers, :schema, :thinking, :tool_prefs, :block

      def initialize(messages:, tools:, temperature:, model:, params:, # rubocop:disable Metrics/ParameterLists
                     headers:, schema:, thinking:, tool_prefs:, block:)
        @messages = messages
        @tools = tools
        @temperature = temperature
        @model = model
        @params = params
        @headers = headers
        @schema = schema
        @thinking = thinking
        @tool_prefs = tool_prefs
        @block = block
      end

      def block_received?
        !@block.nil?
      end
    end
  end
end
