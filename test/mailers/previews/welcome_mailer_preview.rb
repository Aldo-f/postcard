# frozen_string_literal: true

class WelcomeMailerPreview < ActionMailer::Preview
  def greet_new_account
    WelcomeMailer.greet_new_account(Account.last)
  end

  def getting_most_out_of_postcard
    WelcomeMailer.getting_most_out_of_postcard(Account.last)
  end

  def why_have_personal_website
    WelcomeMailer.why_have_personal_website(Account.last)
  end

  def how_i_replaced_twitter
    WelcomeMailer.how_i_replaced_twitter(Account.last)
  end

  def cool_uses_for_personal_website
    WelcomeMailer.cool_uses_for_personal_website(Account.last)
  end

  def social_networks_over
    WelcomeMailer.social_networks_over(Account.last)
  end
end
