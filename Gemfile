# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# FIXME: mastodon-api locks with http gem 3.3, but http gem 5.0.0+ is required on Ruby 2.7+
ruby "2.6.10"

gem "mastodon-api", ">= 2.0.0", require: "mastodon"
gem "rake", require: false
gem "redis"
gem "rollbar"
gem "tweet_sanitizer"
gem "twitter"

group :development do
  gem "dotenv", group: :test
  gem "onkcop", ">= 1.0.0.0", require: false
  gem "pry-byebug", group: :test
  gem "rubocop_auto_corrector", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", ">= 2.0.0.pre", require: false
end

group :test do
  gem "coveralls", require: false
  gem "mock_redis"
  gem "rspec"
  gem "rspec-power_assert"
  gem "vcr"
  gem "webmock"
end
