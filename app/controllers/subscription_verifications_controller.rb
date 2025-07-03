# frozen_string_literal: true

class SubscriptionVerificationsController < ApplicationController
  before_action :set_account, :redirect_if_host_changed

  def show
    @subscription = @account.subscriptions.find(params[:id])

    unless @subscription.valid_verification_token?(params[:token])
      return redirect_to '/', alert: 'Link expired - please sign up again'
    end

    if @account.slug == 'philipithomas'
      # SubscribeContraptionCoNewsletterJob.perform_later(@subscription.email_address.email)
      SubscribeToContraptionGhostJob.perform_later(@subscription.email_address.email)
    end

    @subscription.verify!
    redirect_to '/', notice: 'Email verified!'
  end
end
