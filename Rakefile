task :environment do
  require_relative "./lib/twittodon"

  begin
    require "dotenv"
    Dotenv.load
  rescue LoadError # rubocop:disable Lint/HandleExceptions
  end

  redis = ::Redis.new(url: ENV["REDIS_URL"])

  @service = Twittodon::Service.new(
    twitter_consumer_key:        ENV["TWITTER_CONSUMER_KEY"],
    twitter_consumer_secret:     ENV["TWITTER_CONSUMER_SECRET"],
    twitter_access_token:        ENV["TWITTER_ACCESS_TOKEN"],
    twitter_access_token_secret: ENV["TWITTER_ACCESS_TOKEN_SECRET"],

    mastodon_url:          ENV["MASTODON_URL"],
    mastodon_access_token: ENV["MASTODON_ACCESS_TOKEN"],

    redis: redis,
  )
end

desc "Post toot from twitter"
task :perform => :environment do
  @service.perform(ENV["QUERY"])
end
