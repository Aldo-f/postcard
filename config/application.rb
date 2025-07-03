# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Postcard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # https://github.com/hotwired/turbo-rails/issues/340
    ActiveSupport::KeyGenerator.hash_digest_class = OpenSSL::Digest::SHA1
    config.active_support.key_generator_hash_digest_class = OpenSSL::Digest::SHA1
    config.active_storage.variant_processor = :vips
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_job.queue_adapter = :solid_queue

    config.to_prepare do
      Devise::Mailer.layout 'mail/transactional'
      Devise::Mailer.default reply_to: 'postcard@contraption.co'
      Devise::SessionsController.layout 'whole_page'
      Devise::RegistrationsController.layout 'whole_page'
      Devise::ConfirmationsController.layout 'whole_page'
      Devise::UnlocksController.layout 'whole_page'
      Devise::PasswordsController.layout 'whole_page'
    end

    config.generators do |g|
      g.stylesheets false
      g.helper false
      g.javascripts false
    end
  end
end
