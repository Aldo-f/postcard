# frozen_string_literal: true

class AddApprovedToSubscibersImport < ActiveRecord::Migration[7.0]
  def change
    add_column :subscribers_imports, :approved, :boolean
    add_index :subscribers_imports, :approved
  end
end
