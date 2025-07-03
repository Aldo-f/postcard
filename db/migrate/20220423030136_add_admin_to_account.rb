# frozen_string_literal: true

class AddAdminToAccount < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.boolean :admin, default: false
    end
  end
end
