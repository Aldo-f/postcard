# frozen_string_literal: true

class AnalyticsSummaryEmailJob < ApplicationJob
  queue_as :low

  def perform(*accounts)
    accounts.each do |account|
      AccountMailer.analytics_summary(account).deliver_now
    end
  end
end
