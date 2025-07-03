# frozen_string_literal: true

class BillingController < ApplicationController
  prepend_before_action :authenticate_account!
  before_action :set_account_from_path
  before_action :redirect_in_solo

  def show
    @portal_session = @account.payment_processor.billing_portal(
      return_url: page_url(@account)
    )
    redirect_to @portal_session.url, status: :found, allow_other_host: true
  end

  private

  def redirect_in_solo
    redirect_to page_path(@account) if Rails.configuration.solo_mode
  end
end
