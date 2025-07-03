# frozen_string_literal: true

class AddVisibilityToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :visibility, :integer, null: false, default: 0
    add_index :posts, :visibility
  end
end
