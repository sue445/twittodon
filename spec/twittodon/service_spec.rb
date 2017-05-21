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

      it "calleds @mastodon#create_status" do
        allow(service.mastodon).to receive(:create_status)
        subject

        expected_toot = <<~EOS.strip
          【メンテナンス終了のお知らせ】
          メンテナンスが予定通り終了しました。
          DLはこちら→ https://t.co/ZF8NiA4asq     #キュアぱず (via. Twitter https://twitter.com/precure_app/status/862564095446327296)
        EOS
        expect(service.mastodon).to have_received(:create_status).with(expected_toot, [])
      end
    end

    context "When containing media" do
      before do
        allow(service.mastodon).to receive(:upload_media_url).with(twitter_media_url) { media }
      end

      let(:tweet) do
        tweets = fixture_tweets("search_twitter_including_media", "from:sue445")
        tweets.find { |tweet| !tweet.media.empty? }
      end

      let(:twitter_media_url) { "http://pbs.twimg.com/media/C_yFqwuXgAArPbc.jpg" }

      let(:media) do
        ::Mastodon::Media.new(
          "id" => 963738,
          "type" => "image",
          "url" => "https://img.pawoo.net/media_attachments/files/000/963/738/original/f4cf3b55b7eec010.jpeg",
          "preview_url" => "https://img.pawoo.net/media_attachments/files/000/963/738/small/f4cf3b55b7eec010.jpeg",
          "text_url" => "https://pawoo.net/media/XZjAMJU2SQCKKHyuF2A",
        )
      end

      it "calleds @mastodon#create_status" do
        expect(tweet).not_to be nil

        allow(service.mastodon).to receive(:create_status)
        subject

        expected_toot = "https://t.co/614DF2MgmH https://t.co/D7kRGsA81L (via. Twitter https://twitter.com/sue445/status/863712200489402368)"
        expect(service.mastodon).to have_received(:create_status).with(expected_toot, array_including(kind_of(Numeric)))
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
