# frozen_string_literal: true

class RemoveEmailsCountFromSubscriptionsImport < ActiveRecord::Migration[7.0]
  def change
    remove_column :subscribers_imports, :emails_count # rubocop:disable Rails/ReversibleMigration
  end
end
