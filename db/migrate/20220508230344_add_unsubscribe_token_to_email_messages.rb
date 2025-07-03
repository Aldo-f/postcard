# frozen_string_literal: true

class AddUnsubscribeTokenToEmailMessages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'
    add_column :email_messages, :unsubscribe_token, :uuid, default: 'uuid_generate_v4()', null: false, unique: true
    add_index :email_messages, :unsubscribe_token
    add_column :email_messages, :triggered_unsubscribe, :boolean, default: false, null: false
  end
end
