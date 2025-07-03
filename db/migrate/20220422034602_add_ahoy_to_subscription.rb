# frozen_string_literal: true

class AddAhoyToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :ahoy_subscription_visit_id, :bigint
  end
end
