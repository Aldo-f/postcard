# frozen_string_literal: true

class RenameNewsletterToPost < ActiveRecord::Migration[7.0]
  def change
    rename_table :newsletters, :posts
    rename_column :email_messages, :newsletter_id, :post_id
  end
end
