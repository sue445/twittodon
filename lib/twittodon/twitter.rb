module Twittodon
  class Twitter
    attr_reader :client

    def initialize(consumer_key:, consumer_secret:, access_token:, access_token_secret:)
      @client =
        ::Twitter::REST::Client.new do |config|
          config.consumer_key        = consumer_key
          config.consumer_secret     = consumer_secret
          config.access_token        = access_token
          config.access_token_secret = access_token_secret
        end
    end

    def search(query:, since_id: -1, count: 10)
      client.search(query, since_id: since_id, count: count, tweet_mode: "extended").take(count)
    end

    # @param tweet [Twitter:Tweet]
    # @return [String]
    def self.expand_urls_text(tweet)
      tweet.uris.reverse.each_with_object(tweet.text.dup) do |uri, expanded|
        pos1 = uri.indices[0]
        pos2 = uri.indices[1]
        expanded[pos1, pos2] = uri.expanded_url
      end
    end

    # @param tweet [Twitter:Tweet]
    # @param text [String]
    # @return [String]
    def self.remove_media_urls_in_tweet(tweet, text)
      tweet.media.each_with_object(text.dup) do |media, t|
        t.gsub!(media.url, "")
        t.strip!
      end
    end
  end
end
