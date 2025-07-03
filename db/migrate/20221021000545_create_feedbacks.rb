# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.references :account, null: false, foreign_key: true
      t.string :path, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
