# frozen_string_literal: true

class VerifyDomainsJob < ApplicationJob
  def perform(*_args)
    # Only run in multi-user mode where custom domains are supported
    return unless Rails.configuration.multiuser_mode

    Domain.where(verified: false).order(Arel.sql('RANDOM()')).each do |domain|
      domain.update_verification_status
    rescue StandardError => e
      Rails.logger.error "Error verifying domain #{domain.name}: #{e}"
    end
  end
end
