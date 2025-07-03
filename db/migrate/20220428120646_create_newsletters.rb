# frozen_string_literal: true

class CreateNewsletters < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletters do |t|
      t.references :account, null: false, foreign_key: true
      t.string :subject
      t.timestamp :published_at, null: true, index: true
      t.string :slug, unique: true, index: true

      t.timestamps
    end
  end
end
