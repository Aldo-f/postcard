# frozen_string_literal: true

class AddDomainToAccount < ActiveRecord::Migration[7.0]
  def change
    change_table :domains do |t|
      t.references :account, null: false, foreign_key: { to_table: :accounts }
    end
  end
end
