# frozen_string_literal: true

xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title @account.name
    xml.description @account.description.to_plain_text.truncate(200).presence || @account.name
    xml.link @account.url

    @posts.each do |post|
      xml.item do
        xml.title post.subject
        xml.description post.body
        xml.pubDate post.published_at.to_fs(:rfc822)
        xml.link public_post_url(post, :host => @account.host)
        xml.guid public_post_url(post, :host => @account.host)
      end
    end
  end
end
