# frozen_string_literal: true

class RenameFriendlyIdSlugsFromNewsletterToPost < ActiveRecord::Migration[7.0]
  def change
    FriendlyId::Slug
      .where(sluggable_type: 'Newsletter')
      .update(sluggable_type: 'Post')
  end
end
