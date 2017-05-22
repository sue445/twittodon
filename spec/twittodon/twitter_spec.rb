describe Twittodon::Twitter do
  let(:twitter) do
    Twittodon::Twitter.new(
      consumer_key:        "XXXXXXXXXXXXXXXXXXX",
      consumer_secret:     "XXXXXXXXXXXXXXXXXXX",
      access_token:        "XXXXXXXXXXXXXXXXXXX",
      access_token_secret: "XXXXXXXXXXXXXXXXXXX",
    )
  end

  let(:query) { "from:sue445" }

  let(:since_id) { -1 }

  let(:fixture_name) { "search_twitter_tweet_mode_extended" }

  let(:count) { 10 }

  describe "#search" do
    subject do
      VCR.use_cassette(fixture_name, record: :none, match_requests_on: [:method, :uri]) do
        twitter.search(query: query, since_id: since_id, count: count).take(count)
      end
    end

    it "works" do
      tweets = subject

      aggregate_failures do
        is_asserted_by { tweets.count == count }
        is_asserted_by { tweets[0].id == 866_641_393_837_424_640 }
        is_asserted_by { tweets[0].user.screen_name == "sue445" }
        is_asserted_by { tweets[1].id == 866_638_054_651_445_249 }
        is_asserted_by { tweets[1].user.screen_name == "sue445" }
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
        client.search(query, since_id: since_id, count: count, tweet_mode: "extended").take(count)
      end
    end
  end
end
