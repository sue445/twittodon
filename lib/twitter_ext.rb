require "twitter"

module FullTextExt
  def text
    @attrs[:full_text] || @attrs[:text]
  end
end

Twitter::Tweet.class_eval do
  prepend FullTextExt
end
