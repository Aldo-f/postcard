# frozen_string_literal: true

class EnqueueAnalyticsSummaryEmailsJob < ApplicationJob
  queue_as :critical

  def perform
    # Check if today is Monday
    now = TZInfo::Timezone.get('America/New_York').now
    unless now.monday?
      Rails.logger.info "Not Monday, it is #{now.strftime('%A')} - not sending analytics summary emails"
      return
    end

    Account.where(locked_at:nil).find_each do |account|
      AnalyticsSummaryEmailJob.perform_later(account)
    end
  end
end
