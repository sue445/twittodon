Bundler.require(*[:default, ENV["ENVIRONMENT"]].compact)

module Twittodon
end

require_relative "./twittodon/mastodon"
require_relative "./twittodon/service"
require_relative "./twittodon/twitter"
