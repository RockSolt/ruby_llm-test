# frozen_string_literal: true

require "test_helper"

module RubyLLM
  class TestTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::RubyLLM::Test::VERSION
    end
  end
end
