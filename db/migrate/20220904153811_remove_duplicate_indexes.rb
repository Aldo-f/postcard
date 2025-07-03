# frozen_string_literal: true

class RemoveDuplicateIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :friendly_id_slugs, name: 'index_friendly_id_slugs_on_slug_and_sluggable_type' # rubocop:disable Rails/ReversibleMigration
    remove_index :subscriptions, name: 'index_subscriptions_on_account_id' # rubocop:disable Rails/ReversibleMigration
  end
end
