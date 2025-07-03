# frozen_string_literal: true

class RenameActiveTextTables < ActiveRecord::Migration[7.0]
  def change
    ActiveStorage::Attachment
      .where(record_type: 'Newsletter')
      .update(record_type: 'Post')
  end
end
