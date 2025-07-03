# frozen_string_literal: true

class AddSlugToAccountss < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :slug, :string
    add_index :accounts, :slug, unique: true
    add_column :accounts, :name, :string
  end
end
