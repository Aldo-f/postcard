# frozen_string_literal: true

class EmailMessage < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true
  belongs_to :account, optional: true
  belongs_to :subscription, optional: true
end
