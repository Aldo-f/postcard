# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :account

  validates :message, presence: true

  after_create_commit :send_feedback_email

  private

  def send_feedback_email
    AdminMailer.new_feedback(self).deliver_later
  end
end
