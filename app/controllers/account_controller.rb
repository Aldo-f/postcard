# frozen_string_literal: true

class AccountController < ApplicationController
  prepend_before_action :authenticate_account!
  before_action :set_account_from_path

  def update
    @old_pinned_post = @account.pinned_post

    @account.update!(account_params)

    respond_to do |format|
      format.html { redirect_to page_posts_path(@account), notice: 'Success', status: :see_other }
      format.turbo_stream
    end
  end

  private

  def account_params
    params.require(:account).permit(:pinned_post_id)
  end
end
