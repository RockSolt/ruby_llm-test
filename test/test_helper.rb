# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter %r{^/test/}
  enable_coverage :branch
end

require "ruby_llm/test"
require "minitest/autorun"
