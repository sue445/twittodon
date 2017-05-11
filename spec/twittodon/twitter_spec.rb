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
          twitter.search(query, since_id)
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
        consumer_key:        ENV["CONSUMER_KEY"],
        consumer_secret:     ENV["CONSUMER_SECRET"],
        access_token:        ENV["ACCESS_TOKEN"],
        access_token_secret: ENV["ACCESS_TOKEN_SECRET"],
      ).client
    end

    it "works" do
      VCR.use_cassette fixture_name do
        client.search(query, since_id: since_id)
      end
    end
  end
end
