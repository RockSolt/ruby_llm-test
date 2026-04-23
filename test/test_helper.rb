# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter %r{^/test/}
  enable_coverage :branch
end

require "ruby_llm/test"
require "minitest/autorun"

RubyLLM::Models.singleton_class.prepend(RubyLLM::Test::ResolveWithTestProvider)

# need to provide a dummy value for the API key
# the two models used need to exist in the JSON file that comes with the gem
RubyLLM.configure do |config|
  config.openai_api_key = "dummy-test-api-key"
  config.default_model = "gpt-5.4"
end
