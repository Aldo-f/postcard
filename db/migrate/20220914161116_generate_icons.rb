# frozen_string_literal: true

class GenerateIcons < ActiveRecord::Migration[7.0]
  def change
    Account.find_each(&:generate_icon)
  end
end
