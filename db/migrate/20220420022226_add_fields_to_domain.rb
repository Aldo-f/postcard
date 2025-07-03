# frozen_string_literal: true

class AddFieldsToDomain < ActiveRecord::Migration[7.0]
  def change
    add_column :domains, :redirect_for_name, :string, default: nil
    add_index :domains, :redirect_for_name
    add_column :domains, :apex, :boolean, default: false
  end
end
