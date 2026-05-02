[![Gem Version](https://badge.fury.io/rb/ruby_llm-test.svg)](https://badge.fury.io/rb/ruby_llm-test)
[![Tests](https://github.com/RockSolt/ruby_llm-test/actions/workflows/test.yml/badge.svg)](https://github.com/RockSolt/ruby_llm-test/actions/workflows/test.yml)
[![RuboCop](https://github.com/RockSolt/ruby_llm-test/actions/workflows/rubocop.yml/badge.svg)](https://github.com/RockSolt/ruby_llm-test/actions/workflows/rubocop.yml)

# RubyLLM::Test

How do you test your business logic when it interacts with large language models (LLMs)? From a testing point of view, an LLM is just an external system. To keep tests fast and consistent, pick a boundary then stub or mock the external system.

Part of the appeal of the RubyLLM library is that code using it does not need to know the specifics of provider APIs. The RubyLLM::Test gem brings the same benefit to your tests. No API or provider-specific knowledge is required to stub calls.

Simple stubs make for simple tests. Keep your tests fast, consistent, and thorough with RubyLLM::Test!

```ruby
RubyLLM::Test.stub_response("Outlook good")

chat = RubyLLM.chat
response = chat.ask "What are the odds this works?"

assert_equal "Outlook good", response.content
```

## Installation

Add this line to your application's Gemfile in the test group:

```ruby
gem 'ruby_llm-test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_llm-test

## Usage

Add the following lines to your `spec_helper.rb` or `test_helper.rb`:

```ruby
require 'ruby_llm/test'

RubyLLM::Models.singleton_class.prepend(RubyLLM::Test::ResolveWithTestProvider)
```

Then, in your tests, you can use the `stub_response` method to stub responses from the LLM. For example:

```ruby
it 'returns a stubbed response' do
  RubyLLM::Test.stub_response('Hello, world!')

  response = RubyLLM.chat.ask 'Hello?'
  expect(response.content).to eq('Hello, world!')
end
```

If you make multiple calls to the LLM, you can call `stub_response` more than once or use the `stub_responses` method to stub multiple responses at once. For example:

```ruby
it 'returns multiple stubbed responses' do
  RubyLLM::Test.stub_responses('Blue.', 'No, yellow.')
  chat = RubyLLM.chat
  response1 = chat.ask 'What is your favorite color?'
  response2 = chat.ask 'Are you sure?'

  expect(response1.content).to eq('Blue.')
  expect(response2.content).to eq('No, yellow.')
end
```

### Stubbing with a Message

If you stub with a string, it will be wrapped in a `RubyLLM::Message` with the role of `:assistant`. If you want more control over the message, you can stub with a `RubyLLM::Message` directly. For example:

```ruby
it 'returns a stubbed message' do
  message = RubyLLM::Message.new(role: :assistant, content: 'Hello, world!')
  RubyLLM::Test.stub_response(message)

  response = RubyLLM.chat.ask 'Hello?'
  expect(response).to eq(message)
end
```

### Stubbing with a Hash Returns JSON

If you stub with a hash, it will be converted to a `RubyLLM::Message` with the content set to the JSON representation of the hash. For example:

```ruby
it 'returns a stubbed JSON message' do
  hash = { key: 'value' }
  RubyLLM::Test.stub_response(hash)

  response = RubyLLM.chat.ask 'Hello?'
  expect(response.content).to eq(hash.to_json)
end
```

### Resetting Stubs

Reset stubs before each test to ensure a clean slate.

```ruby
RubyLLM::Test.reset
```

### Stubbing with a Block

You can also stub responses in a block, which handles the setup and teardown of stubs automatically. For example:

```ruby
RubyLLM::Test.with_responses('Hello, world!') do
  response = RubyLLM.chat.ask 'Hello?'
  expect(response.content).to eq('Hello, world!')
end
```

### Testing Arguments

You can verify arguments passed to the LLM by checking the requests received by the test provider with methods `requests` and `last_request`.

```ruby
RubyLLM::Test.stub_response('Hello, world!')
chat = RubyLLM.chat(model: 'gpt-5-nano')
chat.with_tools(GreeterTool)
chat.ask('Hello?')
request = RubyLLM::Test.last_request

assert_equal 'gpt-5-nano', request.model
assert_includes request.tool_classes, GreeterTool
```

Any parameters passed to the Provider's `complete` method are available on the request object. The `tool_classes` method is a helper that returns the classes of any tools included in the request.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RockSolt/ruby_llm-test.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
