describe Twittodon::Twitter do
  let(:twitter) do
    Twittodon::Twitter.new(
      consumer_key:        "XXXXXXXXXXXXXXXXXXX",
      consumer_secret:     "XXXXXXXXXXXXXXXXXXX",
      access_token:        "XXXXXXXXXXXXXXXXXXX",
      access_token_secret: "XXXXXXXXXXXXXXXXXXX",
    )
  end

  let(:query) { "from:precure_app" }

  let(:since_id) { -1 }

  let(:fixture_name) { "search_twitter" }

  describe "#search" do
    subject do
      result =
        VCR.use_cassette(fixture_name, record: :none, match_requests_on: [:method, :uri]) do
          twitter.search(query: query, since_id: since_id, count: 10)
        end
      result.to_a
    end

    it "works" do
      tweets = subject

      aggregate_failures do
        is_asserted_by { tweets.count == 2 }
        is_asserted_by { tweets[0].id == 862_564_095_446_327_296 }
        is_asserted_by { tweets[0].user.screen_name == "precure_app" }
        is_asserted_by { tweets[1].id == 862_233_084_392_988_672 }
        is_asserted_by { tweets[1].user.screen_name == "precure_app" }
      end
    end
  end

  describe "record fixture", record: true do
    let(:client) do
      Twittodon::Twitter.new(
        consumer_key:        ENV["TWITTER_CONSUMER_KEY"],
        consumer_secret:     ENV["TWITTER_CONSUMER_SECRET"],
        access_token:        ENV["TWITTER_ACCESS_TOKEN"],
        access_token_secret: ENV["TWITTER_ACCESS_TOKEN_SECRET"],
      ).client
    end

    let(:query) { "from:sue445" }

    let(:since_id) { -1 }

    let(:fixture_name) { "search_twitter_tweet_mode_extended" }

    it "works" do
      VCR.use_cassette fixture_name do
        client.search(query, since_id: since_id, count: 10, tweet_mode: "extended")
      end
    end
  end
end
