# frozen_string_literal: true

module RubyLLM
  module Test
    # Extend the RubyLLM::Models class to inject the Test Provider in test environments.
    #
    # Add the following to your test setup (e.g. in spec_helper.rb or test_helper.rb):
    #
    # require_relative "ruby_llm/test/resolve_with_test_provider"
    #
    # RubyLLM::Models.singleton_class.prepend(RubyLLM::Test::ResolveWithTestProvider)
    module ResolveWithTestProvider
      def resolve(...)
        model, provider_instance = super
        [ model, Test::TestProvider.new(provider_instance, RubyLLM::Test.send(:harness)) ]
      end
    end
  end
end
