module Twittodon
  require "logger"

  class Service
    UNKNOWN_SINCE_ID = -1

    attr_reader :twitter, :mastodon

    def initialize(twitter_consumer_key:, twitter_consumer_secret:, twitter_access_token:, twitter_access_token_secret:,
                   mastodon_url:, mastodon_access_token:,
                   redis:)

      @twitter = ::Twittodon::Twitter.new(
        consumer_key: twitter_consumer_key,
        consumer_secret: twitter_consumer_secret,
        access_token: twitter_access_token,
        access_token_secret: twitter_access_token_secret,
      )

      @mastodon = ::Twittodon::Mastodon.new(
        mastodon_url: mastodon_url,
        access_token: mastodon_access_token,
      )

      @redis = redis

      @logger = ::Logger.new(STDOUT)
    end

    def perform(query)
      since_id = @redis.get(redis_key(query)) || UNKNOWN_SINCE_ID
      tweets = @twitter.search(query, since_id).to_a.reverse
      @logger.info "Tweets count=#{tweets.count}"

      unless tweets.empty?
        unless since_id == UNKNOWN_SINCE_ID
          tweets.each do |tweet|
            toot_tweet(tweet)
            # TODO: debug
            # break
          end
        end

        save_latest_id(query, tweets)
      end
    end

    def toot_tweet(tweet)
      toot = "#{tweet.text} (via. Twitter #{tweet.uri.to_s})"
      @mastodon.create_status(toot)
      @logger.info "Toot to mastodon: #{toot}"
    end

    def del_since_id_cache(query)
      @redis.del(redis_key(query))
      @logger.info "Delete redis key: #{redis_key(query)}"
    end

    private

      def save_latest_id(query, tweets)
        latest_id = tweets.last.id
        @redis.set(redis_key(query), latest_id)
        @logger.info "Save redis: #{redis_key(query)}=#{latest_id}"
      end

      def redis_key(query)
        "twittodon:#{query}"
      end
  end
end

if $PROGRAM_NAME == __FILE__
  require "dotenv"
  Dotenv.load

  require_relative "../twittodon"

  redis = ::Redis.new(url: ENV["REDIS_URL"])

  service = Twittodon::Service.new(
    twitter_consumer_key:        ENV["TWITTER_CONSUMER_KEY"],
    twitter_consumer_secret:     ENV["TWITTER_CONSUMER_SECRET"],
    twitter_access_token:        ENV["TWITTER_ACCESS_TOKEN"],
    twitter_access_token_secret: ENV["TWITTER_ACCESS_TOKEN_SECRET"],

    mastodon_url:          ENV["MASTODON_URL"],
    mastodon_access_token: ENV["MASTODON_ACCESS_TOKEN"],

    redis: redis,
  )

  service.perform(ENV["QUERY"])
  #service.del_since_id_cache(ENV["QUERY"])
end
