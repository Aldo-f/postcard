# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :authenticate_account!

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.account = current_account
    @feedback.save!
  end

  private

  # Only allow a list of trusted parameters through.
  def feedback_params
    params.require(:feedback).permit(:path, :message)
  end
end
