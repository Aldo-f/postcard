# frozen_string_literal: true

class CreateAhoyClicks < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :ahoy_clicks do |t|
      t.string :campaign, index: true
      t.string :token
      t.timestamps
    end

    add_column :email_messages, :campaign, :string
    add_index :email_messages, :campaign, algorithm: :concurrently

    add_column :email_messages, :token, :string
    add_index :email_messages, :token, algorithm: :concurrently
  end
end
