# frozen_string_literal: true

require "test_helper"

class ToolsTest < Minitest::Test
  class ToolOne < RubyLLM::Tool
    description "This is the first tool"
  end

  class ToolTwo < RubyLLM::Tool
    description "This is the second tool, it has a constructor"

    def initialize(foo:)
      super()
      @foo = foo
    end
  end

  def setup
    RubyLLM::Test.reset
    RubyLLM::Test.stub_response("stubbed response")
  end

  def test_tools_can_be_inspected
    tool_two_instance = ToolTwo.new(foo: "bar")

    chat = RubyLLM::Chat.new(model: "gpt-4-turbo")
    chat.with_tools(ToolOne, tool_two_instance)
    chat.ask("What is the meaning of life?")

    tools = RubyLLM::Test.last_request.tools

    assert_kind_of ToolOne, tools[ToolOne.new.name.to_sym]
    assert_equal tool_two_instance, tools[tool_two_instance.name.to_sym]
  end

  def test_tool_classes_can_be_inspected
    chat = RubyLLM::Chat.new(model: "gpt-4-turbo")
    chat.with_tools(ToolOne, ToolTwo.new(foo: "bar"))
    chat.ask("What is the meaning of life?")

    tool_classes = RubyLLM::Test.last_request.tool_classes

    assert_includes tool_classes, ToolOne
    assert_includes tool_classes, ToolTwo
  end
end
