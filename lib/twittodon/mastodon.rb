module Twittodon
  class Mastodon
    def initialize(mastodon_url:, access_token:)
      @client =
        ::Mastodon::REST::Client.new(
          base_url:     mastodon_url,
          bearer_token: access_token,
        )
    end

    def create_status(text, media_ids = [])
      @client.create_status(text, nil, media_ids)
    end

    def upload_media(file)
      @client.upload_media(file)
    end
  end
end
