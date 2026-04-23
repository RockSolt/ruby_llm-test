# frozen_string_literal: true

require "test_helper"

class ChatTest < Minitest::Test
  def test_chat_response
    RubyLLM::Test.reset
    RubyLLM::Test.stub_response("42")

    chat = RubyLLM::Chat.new(model: "gpt-4")
    response = chat.ask("What is the meaning of life?")

    assert_equal "42", response.content
  end

  def test_block_stub
    RubyLLM::Test.with_responses("stubbed response") do
      chat = RubyLLM::Chat.new(model: "gpt-4")
      response = chat.ask("What is the meaning of life?")

      assert_equal "stubbed response", response.content
    end
  end
end
