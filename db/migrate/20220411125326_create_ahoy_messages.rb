# frozen_string_literal: true

class CreateAhoyMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :email_messages do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :user, polymorphic: true, index: true
      t.string :to, index: true
      t.string :mailer
      t.text :subject
      t.datetime :sent_at
      t.references :account, index: true
      t.references :subscription, index: true
    end
  end
end
