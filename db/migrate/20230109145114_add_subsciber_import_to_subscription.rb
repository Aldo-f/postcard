# frozen_string_literal: true

class AddSubsciberImportToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_reference :subscriptions, :subscribers_import, null: true, foreign_key: true
  end
end
