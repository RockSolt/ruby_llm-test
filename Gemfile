# frozen_string_literal: true

source "https://gem.coop"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in ruby_llm-test.gemspec
gemspec

group :development, :test do
  gem "appraisal", "~> 2.5"
  gem "minitest", "~> 6.0"
  gem "minitest-mock", "~> 5.27"
  gem "rake", "~> 13.0"
  gem "rubocop", "~> 1.86"
  gem "rubocop-minitest", "~> 0.39"
  gem "simplecov", "~> 0.22"
end
