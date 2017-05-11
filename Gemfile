# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

gem "twitter"

group :development do
  gem "dotenv", group: :test
  gem "onkcop", group: :test, require: false
  gem "pry-byebug", group: :test
end

group :test do
  gem "rspec"
  gem "rspec-power_assert"
  gem "vcr"
  gem "webmock"
end
