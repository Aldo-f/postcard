# frozen_string_literal: true

class AddSourceToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :source, :integer, null: false, default: 0
  end
end
