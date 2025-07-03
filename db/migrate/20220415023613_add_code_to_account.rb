# frozen_string_literal: true

class AddCodeToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :code, :string, default: '', null: true
  end
end
