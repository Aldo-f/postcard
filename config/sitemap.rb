# frozen_string_literal: true

# ONLY USED FOR MARKETING SITE

SitemapGenerator::Sitemap.default_host = 'https://postcard.page'
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.create do
  # homepage is automatic
  MarketingPagesController::ALTERNATIVES.each do |slug, _|
    add "/alternative/#{slug}", changefreq: 'monthly', priority: 0.5
  end
end
