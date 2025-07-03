# frozen_string_literal: true

class AddNewsletterIdToEmailMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :email_messages do |t|
      t.references :newsletter, null: true, foreign_key: { to_table: :newsletters }, index: true
    end
  end
end
