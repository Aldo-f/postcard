# frozen_string_literal: true

class AddArchivedToPosts < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.boolean :archived, default: false
    end
  end
end
