# frozen_string_literal: true

Recaptcha.configure do |config|
  # Use fallback test keys only in development
  if Rails.env.development?
    config.site_key = Rails.configuration.hcaptcha[:site_key] || '10000000-ffff-ffff-ffff-000000000001'
    config.secret_key = Rails.configuration.hcaptcha[:secret_key] || '0x0000000000000000000000000000000000000000'
  else
    config.site_key = Rails.configuration.hcaptcha[:site_key]
    config.secret_key = Rails.configuration.hcaptcha[:secret_key]
  end

  config.verify_url = 'https://hcaptcha.com/siteverify'
  config.api_server_url = 'https://hcaptcha.com/1/api.js'
  config.response_limit = 100_000
#  config.hostname = Rails.configuration.base_host
end
