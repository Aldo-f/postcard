# frozen_string_literal: true

class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains do |t|
      t.string :domain, nil: false
      t.boolean :verified, default: false, nil: false
      t.timestamps
    end
    add_index :domains, :domain, unique: true
  end
end
