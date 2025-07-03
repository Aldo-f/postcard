# frozen_string_literal: true

class AddAccentColorToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :accent_color, :string, default: nil
  end
end
