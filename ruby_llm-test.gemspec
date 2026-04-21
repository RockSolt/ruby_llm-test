
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_llm/test/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_llm-test"
  spec.version       = RubyLlm::Test::VERSION
  spec.authors       = ["Todd Kummer"]
  spec.email         = ["todd@rockridgesolutions.com"]

  spec.summary       = "Test application logic by stubbing responses from a RubyLLM::Provider."
  spec.description   = "Provides a RubyLLM::Provider that allows you to stub responses for testing purposes. You can " \
                       "stub individual responses or a sequence of responses, and you can also temporarily stub " \
                       "responses within a block."
  spec.homepage      = "https://github.com/RockSolt/ruby_llm-test"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]

  spec.add_dependency "ruby_llm", ">= 1.14.0"

  spec.add_development_dependency "minitest", "~> 6.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.86"
  spec.add_development_dependency "simplecov", "~> 0.22"
end
