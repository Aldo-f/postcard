# frozen_string_literal: true

module ApplicationHelper
  def canonical_url
    url = URI.parse(request.url)
    url.query = nil
    url.fragment = nil
    url
  end
end
