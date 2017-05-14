describe Twittodon::Service do
  let(:service) do
    Twittodon::Service.new(
      twitter_consumer_key:        "",
      twitter_consumer_secret:     "",
      twitter_access_token:        "",
      twitter_access_token_secret: "",

      mastodon_url:          "",
      mastodon_access_token: "",

      redis: Redis.current,
    )
  end
end
