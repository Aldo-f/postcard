# frozen_string_literal: true

# Application configuration
# This initializer centralizes all configuration from environment variables
# with sensible defaults.

Rails.application.configure do
  # Base configuration
  config.app_mode = ENV.fetch('APP_MODE', 'SOLO').upcase
  config.solo_mode = config.app_mode == 'SOLO'
  config.multiuser_mode = config.app_mode == 'MULTIUSER'

      # Domain configuration
  # Fall back to RENDER_EXTERNAL_HOSTNAME if BASE_HOST is not set or empty
  default_host = if Rails.env.production?
    ENV['RENDER_EXTERNAL_HOSTNAME'] || 'postcard.page'
  else
    'localtest.me'
  end
  config.base_host = ENV['BASE_HOST'].presence || default_host

  # CDN configuration - only enable in multiuser mode
  if config.multiuser_mode
    config.cdn_host = ENV.fetch('CDN_HOST', "a.#{config.base_host}")
  else
    config.cdn_host = config.base_host
  end

  # Mail configuration
  config.default_email_reply_to = ENV.fetch('DEFAULT_EMAIL_REPLY_TO', ENV.fetch('DEFAULT_EMAIL_FROM', 'postcard@contraption.co'))
  config.default_email_from = ENV.fetch('DEFAULT_EMAIL_FROM', 'hello@postcard.page')
  config.default_email_from_name = ENV.fetch('DEFAULT_EMAIL_FROM_NAME', 'Postcard')

  # Admin notifications
  config.admin_chat_url = ENV.fetch('ADMIN_CHAT_URL', nil)

  # AWS configuration
  config.aws = {
    access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil),
    region: ENV.fetch('AWS_REGION', 'us-east-1'),
    storage_bucket: ENV.fetch('AWS_STORAGE_BUCKET', nil)
  }

  # Stripe configuration
  config.stripe = {
    plan: ENV.fetch('STRIPE_PLAN_ID', nil),
    # Additional Stripe configuration for Pay gem
    private_key: ENV.fetch('STRIPE_PRIVATE_KEY', nil),
    public_key: ENV.fetch('STRIPE_PUBLIC_KEY', nil),
    signing_secret: ENV.fetch('STRIPE_SIGNING_SECRET', nil),
    product: ENV.fetch('STRIPE_PRODUCT_ID', nil)
  }

  # Render API configuration (multiuser mode only)
  config.render = {
    api_key: ENV.fetch('RENDER_API_KEY', nil),
    service: ENV.fetch('RENDER_SERVICE_ID', nil)
  }

  # hCaptcha configuration
  config.hcaptcha = {
    site_key: ENV.fetch('HCAPTCHA_SITE_KEY', nil),
    secret_key: ENV.fetch('HCAPTCHA_SECRET_KEY', nil)
  }

  # Google OAuth configuration
  config.google_oauth = {
    client_id: ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil),
    client_secret: ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil)
  }

  # Anonymous telemetry configuration
  # Helps improve Postcard by sending anonymous usage statistics
  # Set DISABLE_ANONYMOUS_TELEMETRY=true to opt out
  config.disable_anonymous_telemetry = ENV.fetch('DISABLE_ANONYMOUS_TELEMETRY', 'false').downcase == 'true'

end