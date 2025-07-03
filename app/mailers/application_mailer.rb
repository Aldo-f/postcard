# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  track_clicks campaign: false

  default reply_to: -> { Rails.application.config.default_email_reply_to }

  default from: -> {
    ActionMailer::Base.email_address_with_name(
      Rails.application.config.default_email_from,
      Rails.application.config.default_email_from_name
    )
  }
  layout 'mailer'
end
