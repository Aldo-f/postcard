# frozen_string_literal: true

class AddFinishedSendingToNewsletter < ActiveRecord::Migration[7.0]
  def change
    add_column :newsletters, :finished_sending, :boolean, default: false, null: false
  end
end
