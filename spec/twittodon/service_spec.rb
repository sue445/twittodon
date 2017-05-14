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

  describe "#toot_tweet" do
    subject { service.toot_tweet(tweet) }

    context "When not containing media" do
      let(:tweet) do
        fixture_tweets("search_twitter", "from:precure_app").first
      end

      it "should called @mastodon#create_status" do
        allow(service.mastodon).to receive(:create_status)
        subject

        expected_toot = <<~EOS.strip
          【メンテナンス終了のお知らせ】
          メンテナンスが予定通り終了しました。
          DLはこちら→ https://t.co/ZF8NiA4asq     #キュアぱず (via. Twitter https://twitter.com/precure_app/status/862564095446327296)
        EOS
        expect(service.mastodon).to have_received(:create_status).with(expected_toot)
      end
    end
  end

  def fixture_tweets(fixture_name, query)
    since_id = -1
    result =
      VCR.use_cassette(fixture_name, record: :none, match_requests_on: [:method, :uri]) do
        service.twitter.search(query, since_id)
      end
    result.to_a
  end
end
