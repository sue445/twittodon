# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby "2.7.0"

gem "mastodon-api", ">= 2.0.0", require: "mastodon"
gem "rake", require: false
gem "redis"
gem "rollbar"
gem "tweet_sanitizer"
gem "twitter"

group :development do
  gem "dotenv", group: :test

  # TODO: Remove after following PR are merged
  # * https://github.com/onk/onkcop/pull/62
  # * https://github.com/onk/onkcop/pull/63
  # * https://github.com/onk/onkcop/pull/65
  # gem "onkcop", ">= 0.53.0.3", require: false
  gem "onkcop", require: false, github: "sue445/onkcop", branch: "develop"

  gem "pry-byebug", group: :test
  gem "rubocop-performance", require: false
end

group :test do
  gem "coveralls", require: false
  gem "mock_redis"
  gem "rspec"
  gem "rspec-power_assert"
  gem "vcr"
  gem "webmock"
end
