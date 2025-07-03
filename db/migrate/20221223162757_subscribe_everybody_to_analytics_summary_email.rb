# frozen_string_literal: true

class SubscribeEverybodyToAnalyticsSummaryEmail < ActiveRecord::Migration[7.0]
  def change
    Account.where(source: :signup).find_each(batch_size: 100) do |account|
      account.subscribe(AccountMailer::ANALYTICS_SUMMARY_LIST)
    end
  end
end
