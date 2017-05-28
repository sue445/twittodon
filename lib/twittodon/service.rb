module Twittodon
  require "logger"

  class Service
    UNKNOWN_SINCE_ID = -1

    REDIS_KEY_PREFIX = "twittodon:".freeze

    attr_reader :twitter, :mastodon

    # @param twitter_consumer_key [String]
    # @param twitter_consumer_secret [String]
    # @param twitter_access_token [String]
    # @param twitter_access_token_secret [String]
    # @param mastodon_url [String]
    # @param mastodon_access_token [String]
    # @param redis [Redis]
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

    # @param query [String] search query
    # @param max_count [Integer] Number of posts toot
    def perform(query, max_count)
      since_id = @redis.get(redis_key(query)) || UNKNOWN_SINCE_ID
      tweets = @twitter.search(query: query, since_id: since_id, count: max_count).reverse
      @logger.info "Tweets count=#{tweets.count}"

      return if tweets.empty?

      unless since_id == UNKNOWN_SINCE_ID
        tweets.each do |tweet|
          capture_error do
            toot_tweet(tweet)
          end
        end
      end

      save_latest_id(query, tweets.last.id)
    end

    # @param tweet [Twitter::Tweet]
    def toot_tweet(tweet)
      medias = upload_twitter_medias_to_mastodon(tweet.media)

      text = expanded_display_tweet(tweet)
      toot = "#{text}\n\n(via. Twitter #{tweet.uri})"
      @mastodon.create_status(toot, medias.map(&:id))
      @logger.info "Toot to mastodon: #{toot}"
    end

    def delete_since_id(query)
      since_id = @redis.get(redis_key(query))
      @redis.del(redis_key(query))
      @logger.info "Deleted query='#{query}', since_id=#{since_id}"
    end

    def delete_all_since_ids
      since_id_keys = @redis.keys("#{REDIS_KEY_PREFIX}*")
      since_id_keys.each do |key|
        query = key.gsub(REDIS_KEY_PREFIX, "")
        delete_since_id(query)
      end
    end

    def display_since_ids
      since_id_keys = @redis.keys("#{REDIS_KEY_PREFIX}*")
      since_id_keys.each do |key|
        since_id = @redis.get(key)
        query = key.gsub(REDIS_KEY_PREFIX, "")
        @logger.info "query='#{query}', since_id=#{since_id}"
      end
    end

    # @param twitter_medias [Array<Twitter::Media>]
    # @return [Array<Mastodon::Media>]
    def upload_twitter_medias_to_mastodon(twitter_medias)
      return [] if twitter_medias.empty?

      uploadable_medias = twitter_medias.select { |twitter_media| uploadable_media?(twitter_media) }
      return [] if uploadable_medias.empty?

      uploadable_medias.each_with_object([]) do |twitter_media, m|
        m << @mastodon.upload_media_url(twitter_media.media_url.to_s)
      end
    end

    private

      def uploadable_media?(twitter_media)
        [
          ::Twitter::Media::Photo,
          ::Twitter::Media::AnimatedGif,
        ].any? do |media_class|
          twitter_media.is_a?(media_class)
        end
      end

      def save_latest_id(query, latest_id)
        @redis.set(redis_key(query), latest_id)
        @logger.info "Save redis: #{redis_key(query)}=#{latest_id}"
      end

      def redis_key(query)
        "#{REDIS_KEY_PREFIX}#{query}"
      end

      def expanded_display_tweet(tweet)
        expanded_text = Twittodon::Twitter.expand_urls_text(tweet)
        Twittodon::Twitter.remove_media_urls_in_tweet(tweet, expanded_text)
      end

      # Ignore error (but send to rollbar)
      def capture_error
        yield
      rescue Exception => error # rubocop:disable Lint/RescueException
        puts error.message
        error.backtrace.each do |backtrace|
          puts "        from #{backtrace}"
        end

        Rollbar.error(error)
      end
  end
end
