# frozen_string_literal: true

class CreateSubscribersImports < ActiveRecord::Migration[7.0]
  def change
    create_table :subscribers_imports do |t|
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
