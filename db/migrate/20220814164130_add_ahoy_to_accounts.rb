# frozen_string_literal: true

class AddAhoyToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :ahoy_signup_visit_id, :bigint
  end
end
