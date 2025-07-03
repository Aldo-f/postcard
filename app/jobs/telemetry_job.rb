# frozen_string_literal: true

class TelemetryJob < ApplicationJob
  queue_as :low_priority

  PLAUSIBLE_ENDPOINT = 'https://telegraph.contraption.co/api/event'

  def perform
    return if Rails.configuration.disable_anonymous_telemetry

    send_telemetry_event
  rescue StandardError => e
    # Silently fail - telemetry should never interrupt service
    Rails.logger.debug "Telemetry error: #{e.message}" if Rails.env.development?
  end

  private

  def send_telemetry_event
    uri = URI.parse(PLAUSIBLE_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.read_timeout = 1 # Very short timeout to avoid blocking
    http.open_timeout = 1

    request = Net::HTTP::Post.new(uri.request_uri)
    request['User-Agent'] = 'Postcard'
    request['Content-Type'] = 'application/json'
    request.body = telemetry_body.to_json

    http.request(request)
  end

  def telemetry_body
    {
      name: 'pageview',
      domain: 'postcard-os',
      url: 'app://postcard-os/',
      props: telemetry_properties
    }
  end

  def telemetry_properties
    {
      app_mode: Rails.configuration.app_mode,
      is_solo_mode: Rails.configuration.solo_mode,
      rails_env: Rails.env,
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      account_count: Account.count,
      post_count: Post.published.count,
      subscriber_count: Subscription.active.count
    }.compact
  end
end