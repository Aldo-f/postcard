# frozen_string_literal: true

class ActivationController < ApplicationController
  before_action :set_account
  layout 'whole_page'

  def show
    AdminMailer.with(account: @account).activation_visit.deliver_later
  end

  def update
    if @account.update(account_params)
      sign_in @account
      @account.register_first_sign_in_actions
      redirect_to page_path(@account.slug), notice: 'Your account has been activated.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end

  def set_account
    @account = Account.from_verifier!(params[:token], Verifiable::VERIFIER_ACTIVATION)
    redirect_to new_session_path('account') if @account.sign_in_count.positive?
  end
end
