# frozen_string_literal: true

module Ahoy
  class Visit < ApplicationRecord
    self.table_name = 'ahoy_visits'

    has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
    belongs_to :account, optional: true, foreign_key: :user_id, inverse_of: :visits
  end
end
