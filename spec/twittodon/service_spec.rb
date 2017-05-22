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

  let(:count) { 10 }

  describe "#toot_tweet" do
    subject { service.toot_tweet(tweet) }

    context "When not containing media" do
      let(:tweet) do
        fixture_tweets("search_twitter_tweet_mode_extended", "from:sue445")[3]
      end

      it "calleds @mastodon#create_status" do
        allow(service.mastodon).to receive(:create_status)
        subject

        expected_toot = "“GitHubのリポジトリをDprecatedにするスクリプト | Web Scratch” https://t.co/vG7cvDAMEb (via. Twitter https://twitter.com/sue445/status/866636479061147648)"
        expect(service.mastodon).to have_received(:create_status).with(expected_toot, [])
      end
    end

    context "When containing media" do
      before do
        allow(service.mastodon).to receive(:upload_media_url).with(twitter_media_url) { media }
      end

      let(:tweet) do
        fixture_tweets("search_twitter_tweet_mode_extended", "from:sue445")[8]
      end

      let(:twitter_media_url) { "http://pbs.twimg.com/media/DAbk6P4XgAA2RSm.jpg" }

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
        expect(tweet.media).not_to be nil

        allow(service.mastodon).to receive(:create_status)
        subject

        expected_toot = "【ゆるぼ】 #キュアぱず フレンド募集中 \n\n6sup2e https://t.co/3WwBFHkTif (via. Twitter https://twitter.com/sue445/status/866631687920275456)"
        expect(service.mastodon).to have_received(:create_status).with(expected_toot, array_including(kind_of(Numeric)))
      end
    end
  end

  def fixture_tweets(fixture_name, query)
    since_id = -1
    VCR.use_cassette(fixture_name, record: :none, match_requests_on: [:method, :uri]) do
      service.twitter.client.search(query, since_id: since_id, count: count, tweet_mode: "extended").take(count)
    end
  end
end
