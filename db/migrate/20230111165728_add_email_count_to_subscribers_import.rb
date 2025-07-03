# frozen_string_literal: true

class AddEmailCountToSubscribersImport < ActiveRecord::Migration[7.0]
  def change
    add_column :subscribers_imports, :emails_count, :integer, default: 0, null: false
    add_column :subscribers_imports, :sources_description, :text, default: '', null: false
  end
end
