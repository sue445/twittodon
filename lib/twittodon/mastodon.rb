module Twittodon
  require "open-uri"

  class Mastodon
    attr_reader :client

    def initialize(mastodon_url:, access_token:)
      @client =
        ::Mastodon::REST::Client.new(
          base_url:     mastodon_url,
          bearer_token: access_token,
        )
    end

    def create_status(text, media_ids = [])
      if media_ids.empty?
        @client.create_status(text)
      else
        @client.create_status(text, media_ids: media_ids)
      end
    end

    # Download url and upload to mastodon
    # @param media_url [String] url for upload file
    # @return [Mastodon::Media]
    def upload_media_url(media_url)
      tempfile = Tempfile.open(["media", File.extname(media_url)])

      open(media_url) do |input| # rubocop:disable Security/Open
        tempfile.write(input.read)
      end

      @client.upload_media(tempfile.path)
    ensure
      tempfile.close! if tempfile
    end
  end
end
