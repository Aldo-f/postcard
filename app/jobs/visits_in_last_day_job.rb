# frozen_string_literal: true

class VisitsInLastDayJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Collect account IDs that had at least one visit in the last 24 hours
    account_ids = Ahoy::Event.where("time > ?", 1.day.ago).pluck(:user_id).uniq

    # Fetch the corresponding Account records
    accounts = Account.where(id: account_ids)

    # Build a multiline message suitable for the admin chat webhook
    message_lines = [
      "#{accounts.count} people used Postcard in the last day: "
    ]

    if accounts.any?
      # Append each account on its own line: "Account Name https://example.com"
      message_lines += accounts.map { |a| "- #{a.name} #{a.url}" }
    else
      # Sad face if nobody visited 😢
      message_lines << "" << "😢"
    end

    PostInAdminChatJob.perform_later(message_lines.join("\n"))
  end
end
