# frozen_string_literal: true

class AddLockableToDevise < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :locked_at, :datetime
  end
end
