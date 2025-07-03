# frozen_string_literal: true

class SetDefaultPinnedPost < ActiveRecord::Migration[7.0]
  def change
    Account.find_each do |account|
      account.update pinned_post: account.posts.published.first
    end
  end
end
