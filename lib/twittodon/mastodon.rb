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

    # Download url and upload to mastodon
    # @param media_url [String] url for upload file
    # @return [Mastodon::Media]
    def upload_media_url(media_url)
      tempfile = Tempfile.open(["media", File.extname(media_url)])

      open(media_url) do |input|
        tempfile.write(input.read)
      end

      @client.upload_media(HTTP::FormData::File.new(tempfile))
    ensure
      tempfile.close! if tempfile
    end
  end
end
