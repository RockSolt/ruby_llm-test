# RubyLLM::Test

This gem provides testing utilities for RubyLLM, a Ruby library for working with large language models (LLMs). It enables calls to LLM's to be stubbed so that the surrounding application logic can be tested without making actual calls to the LLM. This is particularly useful for testing code that interacts with LLMs, as it allows developers to simulate responses from the LLM without incurring the cost, latency, or randomness of real API calls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_llm-test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_llm-test

## Usage

Add the following lines to your `spec/spec_helper.rb` or `test/test_helper.rb`:

```ruby
require 'ruby_llm/test'

RubyLLM::Models.singleton_class.prepend(RubyLLM::Test::ResolveWithTestProvider)
```

Then, in your tests, you can use the `stub_response` method to stub responses from the LLM. For example:

```ruby
it 'returns a stubbed response' do
  RubyLLM::Test.stub_response('Hello, world!')

  response = MyLLMClient.call('Hello?')
  expect(response).to eq('Hello, world!')
end
```

If you make multiple calls to the LLM, you can call `stub_response` more than once or use method `stub_responses` to stub multiple responses at once. For example:

```ruby
it 'returns multiple stubbed responses' do
  RubyLLM::Test.stub_responses(['Hello, world!', 'How are you?'])
  response1 = MyLLMClient.call('Hello?')
  response2 = MyLLMClient.call('How are you?')

  expect(response1).to eq('Hello, world!')
  expect(response2).to eq('How are you?')
end
```

### Resetting Stubs

Make sure to reset stubs after each test to avoid interference before or between tests.

```ruby
RubyLLM::Test.reset
```

### Stubbing with a Block

You can also stub responses in a block, which handles the setup and teardown of stubs automatically. For example:

```ruby

RubyLLM::Test.stub_response('Hello, world!') do
  response = MyLLMClient.call('Hello?')
  expect(response).to eq('Hello, world!')
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RockSolt/ruby_llm-test.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
