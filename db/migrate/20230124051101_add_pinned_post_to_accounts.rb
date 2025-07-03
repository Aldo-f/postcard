# frozen_string_literal: true

class AddPinnedPostToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :accounts, :pinned_post, foreign_key: { to_table: :posts }
  end
end
