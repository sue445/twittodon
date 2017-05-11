Bundler.require(:default, ENV["ENVIRONMENT"])

module Twittodon
end

require_relative "./twittodon/twitter"
