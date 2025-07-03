# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :email_address, null: false, foreign_key: true
      t.column :source, :integer, null: false

      t.string :verification_digest
      t.datetime :verification_created_at

      t.datetime :verified_at

      t.datetime :unsubscribed_at, null: true, default: nil

      t.timestamps
    end

    add_index :subscriptions, %i[account_id email_address_id], unique: true
    add_index :subscriptions, :verified_at
    add_index :subscriptions, :unsubscribed_at
  end
end
