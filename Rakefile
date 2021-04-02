require "rollbar/rake_tasks"

task :environment do
  require_relative "./lib/twittodon"

  begin
    require "dotenv"
    Dotenv.load
  rescue LoadError # rubocop:disable Lint/SuppressedException
  end

  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  end

  redis = ::Redis.new(url: ENV["HEROKU_REDIS_TEAL_URL"] || ENV["REDIS_URL"])

  @service = Twittodon::Service.new(
    twitter_consumer_key:        ENV["TWITTER_CONSUMER_KEY"],
    twitter_consumer_secret:     ENV["TWITTER_CONSUMER_SECRET"],
    twitter_access_token:        ENV["TWITTER_ACCESS_TOKEN"],
    twitter_access_token_secret: ENV["TWITTER_ACCESS_TOKEN_SECRET"],

    mastodon_url:                ENV["MASTODON_URL"],
    mastodon_access_token:       ENV["MASTODON_ACCESS_TOKEN"],

    redis:                       redis,
  )
end

desc "Post toot from twitter"
task :perform => :environment do
  max_count = ENV["MAX_COUNT"] || 10
  @service.perform(ENV["QUERY"], max_count.to_i)
end

namespace :since_id do
  desc "Display all since_ids"
  task :display => :environment do
    @service.display_since_ids
  end

  desc "Delete speficied since_id"
  task :delete => :environment  do
    query = ENV["QUERY"]
    @service.delete_since_id(query)
  end

  desc "Delete all since_ids"
  task :delete_all => :environment do
    @service.delete_all_since_ids
  end
end
