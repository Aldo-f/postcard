# frozen_string_literal: true

class SubscribeAccountsToUpdates < ActiveRecord::Migration[7.0]
  def change
    Account.where.not(confirmed_at: nil).find_each(&:subscribe_to_updates)
  end
end
