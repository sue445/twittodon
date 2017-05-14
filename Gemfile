# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

# NOTE: https://github.com/tootsuite/mastodon-api/pull/11 is not released
# TODO: Use rubygems.org instead of github after v1.1.0+ is released
gem "mastodon-api", require: "mastodon", github: "tootsuite/mastodon-api", branch: "master", ref: "39f4b0"

gem "redis"
gem "twitter"

group :development do
  gem "dotenv", group: :test
  gem "onkcop", group: :test, require: false
  gem "pry-byebug", group: :test
end

group :test do
  gem "mock_redis"
  gem "rspec"
  gem "rspec-power_assert"
  gem "vcr"
  gem "webmock"
end
