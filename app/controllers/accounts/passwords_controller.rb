# frozen_string_literal: true

module Accounts
  class PasswordsController < Devise::PasswordsController
    prepend_before_action :check_captcha, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

    private

    def check_captcha
      return if verify_recaptcha

      self.resource = resource_class.new

      respond_with_navigational(resource) do
        flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
        render :new
      end
    end
  end
end
