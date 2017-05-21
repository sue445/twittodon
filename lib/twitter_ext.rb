require "twitter"

module FullTextExt
  def text
    @attrs[:text] || @attrs[:full_text]
  end
end

Twitter::Tweet.class_eval do
  prepend FullTextExt
end
