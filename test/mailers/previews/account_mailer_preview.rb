# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/account_mailer/subscription_verification
  def subscription_verification
    AccountMailer.subscription_verification(Subscription.last)
  end

  def new_post
    AccountMailer.new_post(Post.last, Subscription.last)
  end
end
